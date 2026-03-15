# Phase 8: Creator Dashboard - Research

**Researched:** 2026-03-15
**Domain:** SwiftUI creator management interface, mutable data models, form editors, permissions grid
**Confidence:** HIGH

## Summary

Phase 8 adds a creator-side management dashboard to the Blossom Communities prototype. The core challenge is transitioning the data layer from immutable `let` properties (read-only subscriber views) to mutable `var` properties (creator editing), while ensuring changes propagate immediately to subscriber-facing views via the shared `@Observable` CommunityStore. All six requirements (CRTR-01 through CRTR-05, CRTR-07) involve CRUD-style form interfaces built with established SwiftUI patterns already proven in Phases 4-7.

The codebase has strong precedent for every pattern needed: sheet-based forms (ForumComposeSheet), mutable ViewModel arrays (ForumViewModel.threads, FAQViewModel.entries), role-based gating (SubscriptionStore.isSubscribed), and NavigationStack routing (HubsRoute enum). The verified badge (VerifiedBadge, AvatarView.showVerifiedBadge) already exists and simply needs to appear in more places.

**Primary recommendation:** Mutate Community model properties from `let` to `var`, add `isCreator` and `creatorCommunityID` to UserSession, and build the dashboard as a NavigationStack destination from HubsDiscoveryView with card-style section links pushing to dedicated editor sub-screens.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- "Manage my Hub" card at the top of HubsDiscoveryView, above "My Hubs" section -- only visible for creators/ambassadors
- Nick is the default session user and is a creator with a pre-existing community in mock data
- Tapping "Manage my Hub" pushes a CreatorDashboardView onto the NavigationStack
- Dashboard home shows two stat cards (subscriber count, estimated monthly revenue) at top
- Below stats: card-style section links pushing to sub-screens: Edit Community, Manage Tiers, Permissions, Publish Content
- Earnings section shown as placeholder with "Coming soon" label (Phase 9)
- Edits reflect immediately in subscriber-facing views via @Observable CommunityStore
- Tier editor: list of tier cards, tapping opens form sheet to edit name, price, benefits; "Add Tier" button when < 4 tiers
- Benefits editable as a list with add/remove
- Permissions matrix: visual grid -- rows = sections (Posts, Discussions, FAQ Submit, Videos), columns = tiers, toggle switches per cell
- Creator can publish Text Post, Trade Highlight, YouTube Link via segmented control
- Collection assignment via dropdown picker; tier gate assignment via dropdown picker
- Trade Highlight ticker entry: `$AMD, $TSLA` -- dollar-sign prefix parsed into ticker tags on publish
- YouTube Link post: text field for URL input
- Published post appears at top of content feed immediately

### Claude's Discretion
- Exact form field styling and spacing
- How to handle the `isCreator` flag on UserSession (bool, or community ID reference)
- Whether to make Community model properties mutable or use a separate editing model
- Loading/success states for publish actions
- Empty state for dashboard sections

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| CRTR-01 | Creator dashboard accessible via role toggle or separate entry point | "Manage my Hub" card in HubsDiscoveryView, gated by `isCreator` on UserSession; HubsRoute.creatorDashboard case |
| CRTR-02 | Community setup: create community with logo, banner, title, description, link-tree config | Community model `let` -> `var` mutation; CommunityEditView form with TextField bindings; changes write directly to CommunityStore.communities array |
| CRTR-03 | Tier configuration: 1-4 tiers with names, prices, benefits, permissions | TierEditorView with .sheet(item:) form; max 4 tier guard; Tier properties become `var`; benefits as editable list |
| CRTR-04 | Permission management: which tiers access which forums, FAQ submit, content collections | PermissionsMatrixView grid with Toggle per cell; new `permissions` dict on Community model; drives existing `canAccess` checks |
| CRTR-05 | Content publishing: create posts, assign to collections, set tier-gate | ComposePostView with segmented PostType picker; ticker parser for `$` prefix; insert at index 0 of community.posts |
| CRTR-07 | Verified creator/ambassador badge throughout app | VerifiedBadge and AvatarView.showVerifiedBadge already exist; audit surfaces: discovery cards, forum posts, FAQ entries |
</phase_requirements>

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| SwiftUI | iOS 26 | All UI views, forms, navigation | Project standard from Phase 1 |
| Swift 6.2 | 6.2 | Strict concurrency, @Observable | Project standard from Phase 1 |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| Foundation | iOS 26 | UUID, Date, Decimal, string parsing | Model layer, ticker parsing |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Direct Community mutation | Separate EditingModel struct | Extra mapping layer adds complexity for no benefit in a mock-data prototype -- mutate directly |
| `isCreator: Bool` on UserSession | `creatorCommunityID: UUID?` | UUID? is more expressive -- nil means non-creator, non-nil gives the community ID in one field |

## Architecture Patterns

### Recommended Project Structure
```
Features/Hubs/Creator/
    CreatorDashboardView.swift        # Dashboard home with stat cards + section links
    CreatorDashboardViewModel.swift   # Stats computation, section navigation
    CommunityEditView.swift           # Edit community details form
    TierEditorView.swift              # Tier list + add tier
    TierEditSheet.swift               # Single tier edit form (sheet)
    PermissionsMatrixView.swift       # Section x tier toggle grid
    ComposePostView.swift             # Post creation form with type switcher
```

### Pattern 1: Mutable Community via CommunityStore
**What:** Change Community and sub-model properties from `let` to `var`. Creator edits mutate the community in-place within `CommunityStore.communities` array. Because CommunityStore is `@Observable`, all subscriber views re-render automatically.
**When to use:** Every creator edit action.
**Example:**
```swift
// In CommunityStore
func updateCommunity(id: UUID, update: (inout Community) -> Void) {
    guard let index = communities.firstIndex(where: { $0.id == id }) else { return }
    update(&communities[index])
}

// Usage in a ViewModel
store.updateCommunity(id: communityID) { community in
    community.name = editedName
    community.description = editedDescription
}
```

### Pattern 2: Creator Role on UserSession
**What:** Add `creatorCommunityID: UUID?` to UserSession. Nil means regular subscriber. Non-nil gives both the "is creator" boolean check AND the community reference.
**When to use:** Gating the "Manage my Hub" card, loading the correct community in dashboard.
**Example:**
```swift
struct UserSession: Codable, Sendable {
    let id: UUID
    let name: String
    let username: String
    let profileImageName: String
    var subscriptions: [UUID: Subscription]
    var creatorCommunityID: UUID?  // NEW: nil = subscriber only
}

// In HubsDiscoveryView
if subscriptionStore.session.creatorCommunityID != nil {
    // Show "Manage my Hub" card
}
```

### Pattern 3: Sheet-Based Tier Editing (ForumComposeSheet precedent)
**What:** Tier edit uses `.sheet(item:)` with a NavigationStack inside, toolbar cancel/confirm, Form with TextFields. Matches ForumComposeSheet exactly.
**When to use:** Editing a single tier's name, price, benefits.
**Example:**
```swift
.sheet(item: $editingTier) { tier in
    NavigationStack {
        Form {
            TextField("Tier Name", text: $tierName)
            TextField("Monthly Price", value: $tierPrice, format: .currency(code: "USD"))
            // Benefits list with add/remove
        }
        .navigationTitle("Edit Tier")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { editingTier = nil } }
            ToolbarItem(placement: .confirmationAction) { Button("Save") { saveTier() } }
        }
    }
}
```

### Pattern 4: Permissions Grid as Toggle Matrix
**What:** A grid with rows = content sections and columns = tiers. Each cell is a Toggle. Backed by a dictionary `[String: [Int: Bool]]` on Community.
**When to use:** CRTR-04 permissions management.
**Example:**
```swift
// New property on Community
var permissions: [String: Set<Int>] // section name -> set of tier indices that have access

// Grid rendering
Grid(alignment: .leading) {
    GridRow {
        Text("") // Corner cell
        ForEach(Array(community.tiers.enumerated()), id: \.offset) { idx, tier in
            Text(tier.name).font(BlossomFont.caption)
        }
    }
    ForEach(permissionSections, id: \.self) { section in
        GridRow {
            Text(section).font(BlossomFont.subhead)
            ForEach(Array(community.tiers.enumerated()), id: \.offset) { idx, tier in
                Toggle("", isOn: permissionBinding(section: section, tierIndex: idx))
                    .labelsHidden()
            }
        }
    }
}
```

### Pattern 5: Ticker Parsing for Trade Highlights
**What:** Parse `$AMD, $TSLA` input into `["$AMD", "$TSLA"]` array. Simple regex or string split on dollar-sign prefix.
**When to use:** ComposePostView when postType == .tradeHighlight.
**Example:**
```swift
func parseTickers(from input: String) -> [String] {
    let pattern = /\$[A-Za-z.]+/
    return input.matches(of: pattern).map { String($0.output) }
}
```

### Anti-Patterns to Avoid
- **Separate editing model with two-way sync:** Adds a mapping layer that must be maintained. The Community struct is small and the prototype has no persistence beyond UserDefaults. Mutate directly.
- **Wrapping creator screens in a new NavigationStack:** The Hubs tab already has a NavigationStack. Push onto it using NavigationLink(value:). Do NOT create a nested NavigationStack.
- **Using `.sheet` for full dashboard navigation:** The dashboard is a pushed view, not a sheet. Sub-screens (Edit Community, Tiers, etc.) are also pushed. Only the single-tier edit form and post compose use sheets.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Currency input formatting | Custom decimal parser | TextField with `.currency(code:)` format style | Handles locale, decimal precision, validation |
| Form layout | Custom VStack with manual padding | SwiftUI `Form` with `Section` | Automatic styling, keyboard avoidance, accessibility |
| Toggle grid alignment | Manual HStack/VStack nesting | SwiftUI `Grid` + `GridRow` (iOS 16+) | Automatic column alignment, cleaner than LazyVGrid for fixed small grids |
| Post insertion with UI update | Manual array manipulation + observation | `CommunityStore.updateCommunity` inout closure | Single mutation point, @Observable triggers view update |

## Common Pitfalls

### Pitfall 1: Community Model Has `let` Properties
**What goes wrong:** Current Community, Tier, Post, Creator all use `let` for their properties. Creator editing requires `var`.
**Why it happens:** Phases 1-7 were subscriber-read-only. No mutation needed until now.
**How to avoid:** Change `let` to `var` on all Community sub-model properties that the creator can edit: name, description, tiers, posts, permissions. Keep `id` and `creator.id` as `let`.
**Warning signs:** Compiler error "Cannot assign to property: 'name' is a 'let' constant."

### Pitfall 2: CommunityStore Array Mutation Not Triggering @Observable
**What goes wrong:** Mutating a property deep inside `communities[index].tiers[j].name` may not trigger @Observable change tracking if done through subscripts without the right access pattern.
**Why it happens:** @Observable tracks property access at the top level. Deep nested mutations need to go through the array subscript properly.
**How to avoid:** Use the `updateCommunity(id:update:)` pattern with an `inout` closure. This ensures the array element is modified in place and @Observable sees the write.
**Warning signs:** Edits save but subscriber views don't update.

### Pitfall 3: NavigationStack Nesting
**What goes wrong:** Creating a new NavigationStack inside CreatorDashboardView causes double navigation bars and broken back-button behavior.
**Why it happens:** CreatorDashboardView is pushed onto the existing Hubs NavigationStack. Adding another NavigationStack creates nesting.
**How to avoid:** CreatorDashboardView must NOT contain a NavigationStack. It uses `.navigationDestination(for:)` on the parent HubsView or uses NavigationLink(value:) within itself, and registers destinations at the HubsView level.
**Warning signs:** Double navigation bars, back button goes to wrong screen.

### Pitfall 4: HubsRoute Enum Not Hashable for New Cases
**What goes wrong:** Adding `.creatorDashboard` or `.creatorEditCommunity(id:)` cases to HubsRoute without maintaining Hashable conformance.
**Why it happens:** HubsRoute uses associated values (String IDs). New cases must also use Hashable-conformant associated values.
**How to avoid:** Follow existing pattern: use `String` for ID parameters (not UUID directly, matching `communityDetail(id: String)` pattern).

### Pitfall 5: Ticker Parsing Edge Cases
**What goes wrong:** Input like `$RY.TO` (Canadian tickers with dots) or `$BRK.B` not parsed correctly.
**Why it happens:** Naive split on `$` or regex that stops at dots.
**How to avoid:** Include dots in the regex pattern: `\$[A-Za-z.]+`. The existing mock data already uses `$RY.TO`, `$CNQ.TO`.
**Warning signs:** Canadian ticker tags missing the `.TO` suffix.

### Pitfall 6: Missing Permissions Model
**What goes wrong:** The current Community model has no permissions data structure. Forum/FAQ access is currently hardcoded by tier index.
**Why it happens:** Phases 5-7 used simple `requiredTierIndex: Int` on posts and threads. A full permissions matrix needs a structured model.
**How to avoid:** Add a `permissions: [String: Set<Int>]` dictionary to Community. Keys are section names ("Posts", "Discussions", "FAQ Submit", "Videos"), values are sets of tier indices with access. Pre-populate in mock data to match existing hardcoded behavior.

## Code Examples

### Creator Entry Point in HubsDiscoveryView
```swift
// Add above the "My Hubs" section in HubsDiscoveryView body
if let creatorCommunityID = subscriptionStore.session.creatorCommunityID {
    NavigationLink(value: HubsRoute.creatorDashboard) {
        HStack(spacing: 12) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 20))
                .foregroundStyle(BlossomTheme.violet)
            VStack(alignment: .leading, spacing: 2) {
                Text("Manage my Hub")
                    .font(BlossomFont.subhead)
                    .fontWeight(.semibold)
                    .foregroundStyle(BlossomTheme.primaryText)
                Text("Edit community, tiers & content")
                    .font(BlossomFont.caption)
                    .foregroundStyle(BlossomTheme.secondaryText)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(BlossomTheme.secondaryText)
        }
        .padding(16)
        .background(BlossomTheme.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
```

### CommunityStore Mutation Helper
```swift
// Add to CommunityStore
func updateCommunity(id: UUID, update: (inout Community) -> Void) {
    guard let index = communities.firstIndex(where: { $0.id == id }) else { return }
    update(&communities[index])
}

func addPost(to communityID: UUID, post: Post) {
    guard let index = communities.firstIndex(where: { $0.id == communityID }) else { return }
    communities[index].posts.insert(post, at: 0)
}
```

### Permissions Matrix Toggle Binding
```swift
private func permissionBinding(section: String, tierIndex: Int) -> Binding<Bool> {
    Binding(
        get: {
            community.permissions[section]?.contains(tierIndex) ?? false
        },
        set: { enabled in
            store.updateCommunity(id: community.id) { community in
                if enabled {
                    community.permissions[section, default: []].insert(tierIndex)
                } else {
                    community.permissions[section, default: []].remove(tierIndex)
                }
            }
        }
    )
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Immutable Community model (`let`) | Mutable Community model (`var`) | Phase 8 | Required for all creator editing |
| No creator role on UserSession | `creatorCommunityID: UUID?` | Phase 8 | Gates dashboard visibility |
| Hardcoded tier-index gating | Structured permissions dictionary | Phase 8 | Enables permissions matrix UI |

**New additions for this phase:**
- `Community.permissions: [String: Set<Int>]` -- permissions matrix data
- `UserSession.creatorCommunityID: UUID?` -- creator role flag
- `HubsRoute.creatorDashboard` -- navigation route
- `CommunityStore.updateCommunity(id:update:)` -- mutation helper
- `CommunityStore.addPost(to:post:)` -- post insertion

## Open Questions

1. **How should permissions interact with existing requiredTierIndex?**
   - What we know: Posts and threads already use `requiredTierIndex: Int`. The permissions matrix is a separate, higher-level concept covering section access.
   - What's unclear: Should the permissions matrix override per-post tier gates, or work alongside them?
   - Recommendation: Permissions matrix controls section-level visibility (can you see Posts at all, can you access Discussions). Per-post `requiredTierIndex` remains for item-level gating within accessible sections. Both must pass for access.

2. **Community detail editing: which fields are editable?**
   - What we know: CONTEXT.md says "logo, banner, title, description, link-tree section configuration."
   - What's unclear: Logo and banner are currently asset catalog image names. Editing them in a prototype would mean swapping between existing assets, not uploading new images.
   - Recommendation: Provide a picker of existing asset catalog images for logo/banner. Title and description are free-text fields.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Xcode XCTest (built-in) |
| Config file | None -- standard Xcode test target |
| Quick run command | `xcodebuild test -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BlossomHubsTests` |
| Full suite command | `xcodebuild test -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16'` |

### Phase Requirements -> Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| CRTR-01 | Creator entry point visible for creators, hidden for non-creators | manual-only | Visual inspection in Simulator | N/A |
| CRTR-02 | Community edit saves reflected in subscriber views | manual-only | Edit title in dashboard, verify on landing page | N/A |
| CRTR-03 | Tier editor CRUD with 1-4 tier constraint | manual-only | Add/edit/remove tiers, verify across surfaces | N/A |
| CRTR-04 | Permissions matrix toggles drive access gates | manual-only | Toggle permission off, verify subscriber view locks | N/A |
| CRTR-05 | Published post appears in feed with correct gating | manual-only | Publish post, check feed and tier gate | N/A |
| CRTR-07 | Verified badge on creator profiles throughout app | manual-only | Visual audit of discovery, forums, FAQ surfaces | N/A |

### Sampling Rate
- **Per task commit:** Visual verification in Simulator
- **Per wave merge:** Full subscriber + creator flow walkthrough
- **Phase gate:** End-to-end: create post as creator, verify as subscriber

### Wave 0 Gaps
None -- this is a UI prototype with no existing test infrastructure. All validation is manual Simulator verification, consistent with Phases 1-7.

## Sources

### Primary (HIGH confidence)
- Codebase inspection: Community.swift, CommunityStore.swift, SubscriptionStore.swift, Subscription.swift (UserSession), HubsRoute, HubsView, HubsDiscoveryView, ForumComposeSheet, ForumViewModel, FAQViewModel, CommunityHubView, CommunityHubViewModel, CommunityLandingSection, AvatarView, VerifiedBadge, ContentFeedViewModel, TiersBottomSheet
- 08-CONTEXT.md: User decisions from discussion phase

### Secondary (MEDIUM confidence)
- SwiftUI Grid API (iOS 16+): used for permissions matrix layout -- standard API, well-documented

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- identical to Phases 1-7, no new dependencies
- Architecture: HIGH -- all patterns have direct precedent in existing codebase (ForumComposeSheet for forms, ForumViewModel for mutable arrays, HubsRoute for navigation)
- Pitfalls: HIGH -- identified through direct code inspection of immutable model properties and navigation patterns

**Research date:** 2026-03-15
**Valid until:** 2026-04-15 (stable -- no external dependencies, all Apple-native)

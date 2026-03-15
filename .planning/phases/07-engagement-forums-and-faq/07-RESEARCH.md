# Phase 7: Engagement — Forums and FAQ - Research

**Researched:** 2026-03-15
**Domain:** SwiftUI forum/FAQ UI with tier-gated access, in-memory state management
**Confidence:** HIGH

## Summary

Phase 7 replaces the two EmptyStateView placeholders in CommunitySectionPager (.discussions and .faq) with fully interactive forum and FAQ views. The existing codebase provides strong foundations: ForumThread and FAQEntry models are already defined in Community.swift, mock data (3-4 threads + 3 FAQ entries per community) is seeded in CommunityStore, tier access checking via SubscriptionStore.currentTier(for:) works, and reusable components (TagView, LockedContentOverlay, AvatarView, TiersBottomSheet) are battle-tested across Phases 4-6.

The primary challenge is that the existing models are immutable (let properties) and live on Community structs. Forum interactions (like toggling, reply adding, thread creation, FAQ submission) require mutable state. The solution is to have ForumViewModel and FAQViewModel own mutable copies of the data, following the ContentFeedViewModel pattern of taking a Community at init and managing derived state internally. No model mutations propagate back to CommunityStore — all interactions are in-memory ViewModel state only.

**Primary recommendation:** Build two ViewModels (ForumViewModel, FAQViewModel) that copy mock data at init and manage all mutable interaction state (likes, replies, new threads, FAQ submissions) in-memory. Reuse existing components extensively — TagView(.tier) for badges, LockedContentOverlay for gating, AvatarView for creator identity. Follow the Phase 6 ContentFeedView pattern exactly: no own ScrollView, @State optional ViewModel initialized in .onAppear, VStack + Spacer for top-alignment.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Forum Thread Layout:**
- Compact list rows (NOT cards) for thread list — dense rows with title, author, tier badge, reply count, like count, timestamp
- Flat reply list (chronological, no nesting) for thread detail — Discord/Slack style
- Heart icon + count for likes — outline = not liked, filled red = liked
- Floating action button (FAB) bottom-right "+" for new thread creation
- Reply text field at bottom of thread detail (chat input style)

**Tier Badge & Creator Reply Visual Treatment:**
- TagView(.tier) pill inline with author name on every forum post and reply
- Creator/ambassador replies: subtle teal tint background + role badge pill ("Creator" or "Ambassador")
- Same teal tint treatment for both roles, different label text only
- Verified checkmark via AvatarView.showVerifiedBadge

**FAQ Zone UX:**
- Accordion/expandable list for FAQ entries
- Inline text field at top of FAQ list for asking questions
- Checkmark + creator attribution for answered entries, clock/pending icon for unanswered
- Answered entries sorted first, then unanswered — most recent within each group
- expandedEntryID UUID? state for single-expansion (TiersBottomSheet pattern)

### Claude's Discretion
None explicitly stated — all major UX decisions were locked in CONTEXT.md.

### Deferred Ideas (OUT OF SCOPE)
- Trade highlight card UI/UX improvement (noted during Phase 6 UAT)
- Search within forums and FAQ (future phase)
- Pinned threads (creator tool — Phase 8)
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| ENGR-01 | Discussion forums with threaded conversations — tier-based access per forum | ForumViewModel manages thread list with requiredTierIndex gating via SubscriptionStore.currentTier(for:). LockedContentOverlay reused for locked state. |
| ENGR-02 | Full post interaction: create threads, reply, like | ForumViewModel owns mutable arrays (threads, replies, likes). FAB triggers ForumComposeSheet. Reply field at bottom of detail. Like toggle updates in-memory immediately. |
| ENGR-03 | Visible tier badges on forum posts | TagView(.tier) pill placed inline with author name. Tier name resolved from community.tiers[requiredTierIndex]. |
| ENGR-04 | FAQ zone with tier-gated question submission | FAQViewModel checks tier permission. Inline text field disabled when permission denied, showing upgrade prompt. |
| ENGR-05 | Creator answers become persistent discoverable FAQ entries | FAQViewModel sorts answered first, expandable accordion shows answer with creator attribution. Mock data already has answered/unanswered entries. |
| ENGR-06 | Creator/ambassador replies have distinct visual treatment | Teal tint background (.opacity(0.08)) on reply row + "Creator"/"Ambassador" role badge pill. Applied in both ForumReplyRow and FAQ answer display. |
</phase_requirements>

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| SwiftUI | iOS 26 | All UI | Project standard — no UIKit |
| @Observable | Swift 5.9+ | ViewModel state | Project pattern across all phases |
| @MainActor | Swift 6.2 | Concurrency safety | Project-wide requirement (FOUND-07) |

### Existing Components to Reuse
| Component | File | Purpose in Phase 7 |
|-----------|------|---------------------|
| TagView(.tier) | Core/Components/TagView.swift | Tier badge pills on forum posts and replies |
| LockedContentOverlay | Core/Components/LockedContentOverlay.swift | Locked forum section for insufficient tier |
| AvatarView | Core/Components/AvatarView.swift | Author avatars with verified badge |
| TiersBottomSheet | Features/Hubs/Preview/TiersBottomSheet.swift | Upgrade prompt when locked |
| EmptyStateView | Core/Components/EmptyStateView.swift | Empty forum/FAQ states |
| BlossomTheme | Core/Theme/BlossomTheme.swift | Color tokens including .teal for creator highlights |
| BlossomFont | Core/Theme/BlossomFont.swift | Typography tokens |

### New TagStyle Needed
| Addition | Where | Purpose |
|----------|-------|---------|
| TagStyle.role | TagView.swift | "Creator" / "Ambassador" badge pill — teal foreground on teal.opacity(0.12) background |

## Architecture Patterns

### Recommended Project Structure
```
Features/Hubs/Forums/
  DiscussionsFeedView.swift       # Top-level view for Discussions section
  ForumThreadRow.swift            # Compact list row for thread list
  ForumThreadDetailView.swift     # Thread detail with flat reply list
  ForumReplyRow.swift             # Individual reply with tier badge + creator highlight
  ForumComposeSheet.swift         # Sheet for creating new thread
  ForumViewModel.swift            # Thread list, likes, replies, tier access
Features/Hubs/FAQ/
  FAQListView.swift               # Accordion list with inline ask field
  FAQEntryRow.swift               # Expandable row with answered/unanswered states
  FAQViewModel.swift              # Question submission, answer display, ordering
```

### Pattern 1: ViewModel as @State Optional (Phase 3/6 Established Pattern)
**What:** Initialize ViewModel lazily in .onAppear because @Environment stores are not available at struct init time
**When to use:** Every view that needs CommunityStore or SubscriptionStore context
**Example:**
```swift
struct DiscussionsFeedView: View {
    let community: Community

    @State private var viewModel: ForumViewModel?
    @Environment(SubscriptionStore.self) private var subscriptionStore

    var body: some View {
        if let viewModel {
            // Main content
        } else {
            ProgressView()
                .onAppear {
                    viewModel = ForumViewModel(community: community)
                }
        }
    }
}
```

### Pattern 2: No Own ScrollView (Phase 6 Critical Pattern)
**What:** Forum and FAQ views participate in the outer CommunityHubView ScrollView via CommunitySectionPager
**When to use:** All pager page views
**Example:**
```swift
// CRITICAL: No ScrollView here — participates in outer CommunityHubView ScrollView
VStack(alignment: .leading, spacing: 0) {
    // Content goes here
    Spacer()
}
```
**Exception:** ForumThreadDetailView is pushed via NavigationLink — it IS a separate screen and CAN have its own ScrollView.

### Pattern 3: Mutable In-Memory State for Interactions
**What:** ForumViewModel copies Community data at init and manages mutable arrays for likes, replies, and new threads
**When to use:** All forum/FAQ interactions
**Example:**
```swift
@MainActor @Observable
final class ForumViewModel {
    let community: Community
    var threads: [ForumThread]  // Mutable copy
    var likedThreadIDs: Set<UUID> = []
    var replies: [UUID: [ForumReply]] = [:]  // threadID -> replies

    init(community: Community) {
        self.community = community
        self.threads = community.threads
    }

    func toggleLike(threadID: UUID) {
        if likedThreadIDs.contains(threadID) {
            likedThreadIDs.remove(threadID)
        } else {
            likedThreadIDs.insert(threadID)
        }
    }
}
```

### Pattern 4: Binding(get:set:) for @Observable Properties
**What:** Use Binding(get:set:) when binding @Observable ViewModel properties to SwiftUI controls
**When to use:** TextField bindings, Picker selections on ViewModel state
**Established in:** Phase 6 (ContentFeedView with CollectionFilterPicker)

### Pattern 5: Tier Access Check Pattern
**What:** Resolve user's tier index and compare against requiredTierIndex
**When to use:** Forum thread access, FAQ submission gating
**Example:**
```swift
private var userTierIndex: Int? {
    guard let tierID = subscriptionStore.currentTier(for: community.id) else {
        return nil
    }
    return community.tiers.firstIndex { $0.id == tierID }
}

func canAccessThread(_ thread: ForumThread) -> Bool {
    guard let index = userTierIndex else { return false }
    return thread.requiredTierIndex <= index
}
```

### Pattern 6: expandedEntryID for Single-Expansion Accordion
**What:** Use UUID? state to track which FAQ entry is expanded — tapping toggles between nil and entry ID
**When to use:** FAQ accordion list
**Established in:** Phase 3 (TiersBottomSheet expandedTierID)
**Example:**
```swift
@State private var expandedEntryID: UUID?

ForEach(viewModel.sortedEntries) { entry in
    FAQEntryRow(
        entry: entry,
        isExpanded: expandedEntryID == entry.id,
        onToggle: {
            withAnimation {
                expandedEntryID = expandedEntryID == entry.id ? nil : entry.id
            }
        }
    )
}
```

### Anti-Patterns to Avoid
- **Own ScrollView inside pager pages:** DiscussionsFeedView and FAQListView must NOT wrap content in ScrollView — they participate in outer CommunityHubView scroll (Phase 6 Pitfall 3)
- **Mutating Community model directly:** Community and its nested arrays are immutable. Copy data into ViewModel and mutate there.
- **NavigationStack inside forum detail:** ForumThreadDetailView is pushed via the existing Hubs NavigationStack — do NOT create a new NavigationStack
- **@Bindable wrapper:** Project uses Binding(get:set:) for @Observable, not @Bindable (Phase 6 decision)

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Tier badge pills | Custom badge view | TagView(.tier) | Already styled with violet color and capsule shape |
| Locked content overlay | Custom lock screen | LockedContentOverlay + TiersBottomSheet | Battle-tested in Phase 6, names the required tier |
| Creator verified badge | Custom checkmark | AvatarView(showVerifiedBadge: true) | Positioned correctly with teal shield icon |
| Relative timestamps | Custom date formatter | Date.formatted(.relative(presentation: .named)) | Used in PostAuthorRow, native API |
| Accordion expansion | Custom toggle state | expandedEntryID UUID? pattern | Proven in TiersBottomSheet Phase 3 |

**Key insight:** 80% of the visual components needed for Phase 7 already exist. The work is wiring them into new view compositions and adding the interaction state layer (ForumViewModel/FAQViewModel).

## Common Pitfalls

### Pitfall 1: ScrollView Nesting
**What goes wrong:** Adding ScrollView inside DiscussionsFeedView or FAQListView breaks the outer CommunityHubView scroll — content becomes unscrollable or jumps
**Why it happens:** Natural instinct to wrap a list in ScrollView, but CommunitySectionPager pages live inside the hub's ScrollView
**How to avoid:** Use VStack (or LazyVStack) without ScrollView. Only ForumThreadDetailView (pushed via navigation) gets its own ScrollView.
**Warning signs:** Content doesn't scroll, nested scroll gestures conflict

### Pitfall 2: Immutable Model Mutation
**What goes wrong:** Trying to modify ForumThread.likeCount or append to Community.threads causes compiler errors
**Why it happens:** All model properties are `let` and Community is a struct
**How to avoid:** ViewModel owns mutable state (var threads: [ForumThread], var likedIDs: Set<UUID>). Display computed values combining base data + ViewModel state.
**Warning signs:** "Cannot assign to property: 'x' is a 'let' constant"

### Pitfall 3: ForumThread Model Missing Reply Data
**What goes wrong:** ForumThread has replyCount: Int but no actual replies array
**Why it happens:** Phase 2 defined minimal models for mock data — replies weren't needed until Phase 7
**How to avoid:** Create a new ForumReply struct and have ForumViewModel manage a [UUID: [ForumReply]] dictionary mapping thread IDs to reply arrays. Generate mock replies in the ViewModel init.
**Warning signs:** No reply data available when building thread detail view

### Pitfall 4: FAB Z-Order in Pager
**What goes wrong:** Floating action button gets clipped or hidden by TabView paging
**Why it happens:** CommunitySectionPager uses .tabViewStyle(.page) which clips content
**How to avoid:** Place the FAB overlay inside DiscussionsFeedView using ZStack or .overlay, not outside the pager
**Warning signs:** FAB disappears when switching sections or scrolling

### Pitfall 5: Creator Identity Resolution
**What goes wrong:** Unable to determine if a reply author is the creator/ambassador for role badge display
**Why it happens:** ForumThread.authorId is UUID but Community.creator.id is the only creator identity
**How to avoid:** Compare reply authorId against community.creator.id. If match, show creator badge. For mock data, create some replies with authorId == creator.id.
**Warning signs:** All replies look the same, no creator distinction

### Pitfall 6: Thread Detail Navigation
**What goes wrong:** ForumThreadDetailView doesn't push correctly or back navigation breaks
**Why it happens:** Navigation must go through the existing HubsRoute system
**How to avoid:** Add a new HubsRoute case (.forumThread(communityID: String, threadID: String)) or use NavigationLink within the forum view that pushes directly in the existing NavigationStack
**Warning signs:** Thread detail opens as sheet instead of push, or back button goes to wrong screen

## Code Examples

### New Model: ForumReply
```swift
struct ForumReply: Identifiable {
    let id: UUID
    let threadID: UUID
    let authorId: UUID
    let authorName: String
    let authorTierName: String
    let content: String
    let likeCount: Int
    let publishedAt: Date
    let isCreator: Bool
    let isAmbassador: Bool

    init(
        id: UUID = UUID(),
        threadID: UUID,
        authorId: UUID,
        authorName: String,
        authorTierName: String,
        content: String,
        likeCount: Int = 0,
        publishedAt: Date,
        isCreator: Bool = false,
        isAmbassador: Bool = false
    ) {
        self.id = id
        self.threadID = threadID
        self.authorId = authorId
        self.authorName = authorName
        self.authorTierName = authorTierName
        self.content = content
        self.likeCount = likeCount
        self.publishedAt = publishedAt
        self.isCreator = isCreator
        self.isAmbassador = isAmbassador
    }
}
```

### Creator/Ambassador Teal Highlight Row
```swift
// ForumReplyRow with teal tint for creator/ambassador
VStack(alignment: .leading, spacing: 8) {
    HStack(spacing: 8) {
        AvatarView(imageName: profileImage, preset: .small,
                   showVerifiedBadge: reply.isCreator || reply.isAmbassador)

        Text(reply.authorName)
            .font(BlossomFont.subhead)

        TagView(tierName, style: .tier)

        if reply.isCreator {
            TagView("Creator", style: .role)
        } else if reply.isAmbassador {
            TagView("Ambassador", style: .role)
        }

        Spacer()
        Text(reply.publishedAt.formatted(.relative(presentation: .named)))
            .font(BlossomFont.caption)
            .foregroundStyle(BlossomTheme.secondaryText)
    }

    Text(reply.content)
        .font(BlossomFont.body)
        .foregroundStyle(BlossomTheme.primaryText)

    // Like button
    Button {
        viewModel.toggleReplyLike(replyID: reply.id)
    } label: {
        HStack(spacing: 4) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundStyle(isLiked ? .red : BlossomTheme.secondaryText)
            Text("\(reply.likeCount)")
                .font(BlossomFont.caption)
                .foregroundStyle(BlossomTheme.secondaryText)
        }
    }
}
.padding(12)
.background(
    (reply.isCreator || reply.isAmbassador)
        ? BlossomTheme.teal.opacity(0.08)
        : Color.clear
)
.clipShape(RoundedRectangle(cornerRadius: 8))
```

### New TagStyle.role Addition
```swift
// Add to TagStyle enum in TagView.swift
case role

// In foregroundColor computed property:
case .role: return BlossomTheme.teal

// In backgroundColor computed property:
case .role: return BlossomTheme.teal.opacity(0.12)
```

### FAQ Entry Row with Accordion
```swift
VStack(alignment: .leading, spacing: 0) {
    // Question header — always visible
    Button {
        onToggle()
    } label: {
        HStack {
            Image(systemName: entry.isAnswered ? "checkmark.circle.fill" : "clock")
                .foregroundStyle(entry.isAnswered ? BlossomTheme.teal : BlossomTheme.secondaryText)
                .font(.system(size: 18))

            Text(entry.question)
                .font(BlossomFont.subhead)
                .foregroundStyle(BlossomTheme.primaryText)
                .multilineTextAlignment(.leading)

            Spacer()

            if entry.isAnswered {
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(BlossomTheme.secondaryText)
            }
        }
    }
    .disabled(!entry.isAnswered)

    // Answer — visible when expanded
    if isExpanded, let answer = entry.answer {
        VStack(alignment: .leading, spacing: 8) {
            Text(answer)
                .font(BlossomFont.body)
                .foregroundStyle(BlossomTheme.primaryText)

            if let answeredBy = entry.answeredBy {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(BlossomTheme.teal)
                    Text("Answered by \(answeredBy)")
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)
                }
            }
        }
        .padding(12)
        .background(BlossomTheme.teal.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.top, 8)
    }

    // Unanswered attribution
    if !entry.isAnswered {
        Text("Asked by \(entry.askedBy)")
            .font(BlossomFont.caption)
            .foregroundStyle(BlossomTheme.secondaryText)
            .padding(.top, 4)
    }
}
.padding(.vertical, 12)
```

### CommunitySectionPager Update
```swift
// Replace EmptyStateView placeholders in sectionPage(for:)
case .discussions:
    DiscussionsFeedView(community: community)
case .faq:
    FAQListView(community: community)
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| ForumThread with replyCount only | ForumReply struct + ViewModel-managed replies | Phase 7 | Enables actual reply display and creation |
| EmptyStateView placeholders | Full interactive forum/FAQ views | Phase 7 | Discussions and FAQ sections become functional |
| TagStyle with 4 cases | TagStyle with 5 cases (.role added) | Phase 7 | Creator/ambassador role badges |

## Open Questions

1. **ForumThreadDetailView Navigation**
   - What we know: HubsRoute enum has communityDetail, communityPreview, mySubscriptions cases
   - What's unclear: Whether to add a new HubsRoute case or use inline NavigationLink
   - Recommendation: Use NavigationLink(value:) with a new HubsRoute.forumThread(communityID:threadID:) case — consistent with existing navigation pattern. Alternatively, use NavigationLink directly within DiscussionsFeedView without routing through HubsRoute since thread detail is a sub-view of the community hub.

2. **Mock Reply Data Generation**
   - What we know: ForumThread has replyCount but no actual reply objects
   - What's unclear: How many mock replies to generate per thread
   - Recommendation: Generate 3-5 mock replies per accessible thread in ForumViewModel.init, including at least one creator reply per thread for ENGR-06 testing. Use community member names from existing mock data.

3. **FAQ Tier Permission Model**
   - What we know: ForumThread has requiredTierIndex. FAQEntry does not have a tier requirement field.
   - What's unclear: Whether FAQ submission permission is per-entry or per-community
   - Recommendation: FAQ submission permission should be community-wide (e.g., tier index >= 1 can ask questions). Hard-code a faqRequiredTierIndex on the ViewModel or use the community's second tier as the threshold. This matches CONTEXT.md which says "only users with the correct tier permission can tap Ask a Question."

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Xcode XCTest (built-in) |
| Config file | None — standard Xcode test target |
| Quick run command | `xcodebuild test -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BlossomHubsTests` |
| Full suite command | `xcodebuild test -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16'` |

### Phase Requirements -> Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| ENGR-01 | Forum thread list with tier gating | manual-only | Visual verification in Simulator | N/A |
| ENGR-02 | Create thread, reply, like interactions | manual-only | Visual verification — in-memory state | N/A |
| ENGR-03 | Tier badges on forum posts | manual-only | Visual verification | N/A |
| ENGR-04 | FAQ tier-gated question submission | manual-only | Visual verification — test with different tier subscriptions | N/A |
| ENGR-05 | Creator answers as persistent FAQ entries | manual-only | Visual verification — check answered/unanswered sort | N/A |
| ENGR-06 | Creator reply visual distinction | manual-only | Visual verification — teal tint + role badge | N/A |

### Sampling Rate
- **Per task commit:** Build and run in Simulator, verify target view visually
- **Per wave merge:** Full app flow from discovery through forum/FAQ interaction
- **Phase gate:** All 5 success criteria verified via Simulator walkthrough

### Wave 0 Gaps
None — this is a UI-focused prototype phase. All validation is visual/manual via Simulator. No unit test infrastructure changes needed.

## Sources

### Primary (HIGH confidence)
- Existing codebase analysis — Community.swift, CommunityStore.swift, CommunitySectionPager.swift, ContentFeedView.swift, ContentFeedViewModel.swift, TagView.swift, LockedContentOverlay.swift, AvatarView.swift, SubscriptionStore.swift
- Phase 7 CONTEXT.md — locked UX decisions from user discussion

### Secondary (MEDIUM confidence)
- SwiftUI Pro skill references — iOS 26 patterns, @Observable data flow, navigation best practices
- Blossom Brand skill — color palette (teal #35C7B2 for creator highlights), spacing conventions

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - all components exist in codebase, patterns established across 6 phases
- Architecture: HIGH - follows exact ContentFeedView/ContentFeedViewModel pattern from Phase 6
- Pitfalls: HIGH - identified from actual codebase constraints (immutable models, scroll nesting, navigation routing)
- Code examples: HIGH - derived from existing codebase patterns with minimal adaptation

**Research date:** 2026-03-15
**Valid until:** 2026-04-15 (stable — SwiftUI prototype, no external dependencies changing)

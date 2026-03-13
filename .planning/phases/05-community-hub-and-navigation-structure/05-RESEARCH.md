# Phase 5: Community Hub and Navigation Structure - Research

**Researched:** 2026-03-13
**Domain:** SwiftUI community landing page, segmented navigation, sticky headers, welcome overlay
**Confidence:** HIGH

## Summary

Phase 5 replaces the `EmptyView()` placeholder at `HubsRoute.communityDetail` with a full community hub experience. The hub has three main UI challenges: (1) a landing page with parallax banner, overlapping community logo, and link-tree navigation rows; (2) a segmented control with swipe-paging between sections; and (3) a sticky segmented control that pins below the header on scroll. All three are achievable with native SwiftUI APIs already used in this project.

The existing codebase provides strong foundations. `CommunityPreviewView` already implements the parallax banner with `.visualEffect`, the `Community` model already has `posts`, `threads`, and `faqEntries` arrays that determine which sections have content, and `SubscriptionStore` provides the tier lookup needed for the badge. The `ConfettiCelebrationView` pattern (overlay with delayed button reveal) directly informs the welcome card implementation.

**Primary recommendation:** Build the community hub as a `ScrollView` with `LazyVStack(pinnedViews: [.sectionHeaders])` where the segmented control lives in a `Section` header, making it natively sticky. Use a `TabView` with `.tabViewStyle(.page(indexDisplayMode: .never))` for swipe-paging between section content views, driven by the same enum binding as the `Picker` segmented control.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Full-width banner image at top with parallax scroll effect (reuse CommunityPreviewView parallax pattern)
- Community logo overlaps bottom edge of banner (half on banner, half below -- Discord/Facebook style)
- Below logo: community name, 1-2 sentence description, member count
- User's current subscription tier shown as a small badge near the community name (e.g., "Premium" in violet)
- Standard iOS back chevron + community name as nav bar title
- Banner images: use generated gradient/color-based placeholders per community (can swap real images later)
- Each community gets a unique placeholder gradient derived from its category or brand
- iOS settings-style list rows for link-tree: SF Symbol icon, section label, right chevron
- Sections are data-driven -- only show sections that have content in the Community model
- Tapping a link-tree item switches to that section via the segmented control (not a new screen push)
- Native iOS segmented control (Picker) for switching between sections
- Segmented control sticks below the header as user scrolls (sticky positioning)
- Swipe left/right between sections (TabView-style paging) AND tapping the control both work
- Post-confetti: welcome overlay card with "Welcome to [Community Name]!" and tier name and "Explore" button
- Welcome card has a subtle shake animation to prompt the user to tap
- Welcome card shown only on first entry per subscription -- returning visits go straight to landing page

### Claude's Discretion
- Whether to show section content counts in link-tree rows
- Default tab when entering community (Landing vs Posts)
- Back navigation pattern (standard back vs custom)
- Exact gradient colors for placeholder banners
- Welcome card shake animation timing and intensity

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| HUB-01 | Community landing page with: community logo, banner image, title, short description | Parallax banner reuse from CommunityPreviewView, overlapping logo via negative offset, gradient placeholders per category, tier badge via TagView(.subscribed) |
| HUB-02 | Link-tree style navigation on landing page -- tappable buttons linking to community sections | iOS settings-style List rows with SF Symbols, data-driven from Community model arrays (posts, threads, faqEntries), tapping switches segmented control selection |
| HUB-08 | Segmented control or tab switching at top of community for navigating between sections | Picker with .segmented style bound to CommunitySection enum, TabView(.page) for swipe paging, LazyVStack pinnedViews for sticky behavior |
</phase_requirements>

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| SwiftUI (native) | iOS 26 | All UI | Project mandate -- no UIKit unless unavoidable |
| Picker(.segmented) | iOS 13+ | Section switching control | Native segmented control, automatic styling |
| TabView(.page) | iOS 14+ | Swipe paging between sections | Native page-style swiping, syncs with binding |
| LazyVStack(pinnedViews:) | iOS 14+ | Sticky segmented control header | Apple's built-in pinned section headers |
| @AppStorage | iOS 14+ | Welcome card "seen" persistence | Already used for splash screen tracking |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| BlossomTheme | project | All colors and semantic tokens | Every view |
| BlossomFont | project | Typography tokens | Every text element |
| TagView(.subscribed) | project | Tier badge display | Landing page tier badge |
| AvatarView | project | Community logo display | Landing page logo |
| SectionHeader | project | Section headers | Link-tree section label |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| LazyVStack pinnedViews | GeometryReader offset tracking | pinnedViews is simpler, native, no manual math |
| TabView(.page) | Custom drag gesture + offset | TabView handles all gesture physics natively |
| Picker(.segmented) | Custom segmented control | Native picker is consistent with iOS, matches project convention |

## Architecture Patterns

### Recommended Project Structure
```
Features/Hubs/Community/
    CommunityHubView.swift          # Main hub container (ScrollView + pinned header)
    CommunityHubViewModel.swift     # @MainActor @Observable, section logic
    CommunityLandingSection.swift   # Banner + logo + description + link-tree
    CommunitySectionPager.swift     # TabView pager with segmented control header
    CommunityLinkTreeRow.swift      # Individual settings-style row
    WelcomeOverlayView.swift        # Post-subscription welcome card
    CommunityBannerView.swift       # Parallax banner with gradient placeholder
```

### Pattern 1: ScrollView + LazyVStack Pinned Section Header
**What:** The segmented control lives inside a `Section` header within a `LazyVStack(pinnedViews: [.sectionHeaders])`. As the user scrolls past the landing content, the segmented control pins to the top.
**When to use:** Whenever a control needs to stick at the top while content scrolls beneath it.
**Example:**
```swift
// Native SwiftUI sticky header pattern
ScrollView {
    LazyVStack(pinnedViews: [.sectionHeaders]) {
        // Landing content (banner, logo, description, link-tree)
        CommunityLandingSection(community: community)

        Section {
            // Paged content below the segmented control
            CommunitySectionPager(
                community: community,
                selectedSection: $viewModel.selectedSection
            )
        } header: {
            // This pins to the top on scroll
            Picker("Section", selection: $viewModel.selectedSection) {
                ForEach(viewModel.availableSections) { section in
                    Text(section.title).tag(section)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(BlossomTheme.background)
        }
    }
}
```

### Pattern 2: TabView Page Style Synced with Picker
**What:** A `TabView` with `.tabViewStyle(.page(indexDisplayMode: .never))` displays section content. The `selection` binding is shared with the `Picker` segmented control, so both swipe gestures and taps drive the same state.
**When to use:** When the user should be able to both tap a control AND swipe between views.
**Example:**
```swift
// CommunitySection enum drives both Picker and TabView
enum CommunitySection: String, CaseIterable, Identifiable {
    case landing = "Home"
    case posts = "Posts"
    case discussions = "Discussions"
    case faq = "FAQ"
    case videos = "Videos"

    var id: String { rawValue }
    var title: String { rawValue }
    var icon: String {
        switch self {
        case .landing: return "house.fill"
        case .posts: return "doc.text.fill"
        case .discussions: return "bubble.left.and.bubble.right.fill"
        case .faq: return "questionmark.circle.fill"
        case .videos: return "play.rectangle.fill"
        }
    }
}

// TabView paging synced with Picker
TabView(selection: $selectedSection) {
    ForEach(availableSections) { section in
        sectionContent(for: section)
            .tag(section)
    }
}
.tabViewStyle(.page(indexDisplayMode: .never))
```

### Pattern 3: Data-Driven Section Availability
**What:** Sections are computed from the Community model. If a community has no threads, the "Discussions" section is omitted from both the Picker and TabView.
**When to use:** Always -- this is a locked decision.
**Example:**
```swift
// In CommunityHubViewModel
var availableSections: [CommunitySection] {
    var sections: [CommunitySection] = [.landing]
    if !community.posts.isEmpty { sections.append(.posts) }
    if !community.threads.isEmpty { sections.append(.discussions) }
    if !community.faqEntries.isEmpty { sections.append(.faq) }
    let hasVideos = community.posts.contains { $0.postType == .youtubeLink }
    if hasVideos { sections.append(.videos) }
    return sections
}
```

### Pattern 4: Welcome Overlay with First-Visit Tracking
**What:** An overlay card shown once after first subscription, tracked per community via `@AppStorage` or SubscriptionStore.
**When to use:** Post-confetti entry to community hub.
**Example:**
```swift
// Track welcome-shown per community in SubscriptionStore or @AppStorage
@AppStorage private var welcomeShownIDs: Set<String> // community IDs that have shown welcome

// Shake animation using phaseAnimator (consistent with Phase 3 pulsating glow pattern)
PhaseAnimator([false, true], trigger: showWelcome) { content, isShaking in
    content
        .rotationEffect(.degrees(isShaking ? 2 : -2))
} animation: { isShaking in
    isShaking ? .easeInOut(duration: 0.08).repeatCount(5) : .easeInOut(duration: 0.08)
}
```

### Pattern 5: Gradient Placeholders per Community Category
**What:** Each community gets a unique gradient derived from its category for the banner when no image exists.
**When to use:** All communities (bannerImageName is nil for all mock data currently).
**Example:**
```swift
// Category-based gradient mapping
static func gradientColors(for category: String) -> [Color] {
    switch category {
    case "Dividend Investing": return [BlossomTheme.teal, BlossomTheme.violet]
    case "Swing Trading": return [BlossomTheme.orange, BlossomTheme.violet]
    case "Options Trading": return [BlossomTheme.violet, BlossomTheme.teal]
    case "Growth Investing": return [BlossomTheme.teal, BlossomTheme.orange]
    case "Value Investing": return [BlossomTheme.violet, BlossomTheme.orange]
    case "Canadian Markets": return [BlossomTheme.orange, BlossomTheme.teal]
    default: return [BlossomTheme.violet, BlossomTheme.teal]
    }
}
```

### Anti-Patterns to Avoid
- **Nested ScrollViews:** Do NOT put a ScrollView inside the TabView pages when the outer container is already a ScrollView. This causes competing gesture recognizers. Use fixed-height content or LazyVStack inside the pager instead.
- **NavigationLink for section switching:** The user decided tapping link-tree items switches the segmented control, NOT pushing a new screen. Do not use NavigationLink for link-tree rows.
- **Manual offset tracking for sticky header:** Use `LazyVStack(pinnedViews:)` instead of manually reading GeometryReader offsets. The native solution handles edge cases better.
- **Storing @AppStorage in @Observable class:** Per swiftui-pro skill rules, @AppStorage must live in View structs, not @Observable classes. Track welcome-shown state in the View or use UserDefaults directly in the store.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Sticky header on scroll | GeometryReader + PreferenceKey offset tracking | LazyVStack(pinnedViews: [.sectionHeaders]) | Native API handles all edge cases including safe area, dynamic type |
| Swipe paging between views | Custom DragGesture + animation | TabView(.page) | Physics, gesture cancellation, and momentum are handled natively |
| Segmented control | Custom HStack with buttons | Picker(.segmented) | Native accessibility, Dynamic Type support, iOS styling |
| Parallax banner | UIScrollViewDelegate | .visualEffect { } modifier | Already proven in CommunityPreviewView, declarative |
| Shake animation | Manual Timer + offset toggling | PhaseAnimator | Consistent with Phase 3 pulsating glow pattern |
| First-visit tracking | File system flags | @AppStorage or UserDefaults | Simple, persistent, already used for splash screen |

**Key insight:** Every major UI element in this phase has a native SwiftUI equivalent. The project explicitly avoids UIKit and third-party UI libraries (ComponentsKit is the only approved SPM dependency, and it's not a UI framework).

## Common Pitfalls

### Pitfall 1: Competing Scroll Gestures (Nested ScrollView + TabView.page)
**What goes wrong:** If TabView(.page) is inside a ScrollView, the horizontal swipe gesture conflicts with the vertical scroll. Users get stuck or see janky behavior.
**Why it happens:** Both views compete for the same drag gesture.
**How to avoid:** Make the TabView page content fixed-height or use `.frame(height:)` on the TabView so the outer ScrollView handles all vertical scrolling. Alternatively, use a different architecture where the segmented control content replaces the ScrollView content entirely rather than being nested.
**Warning signs:** Horizontal swipe sometimes scrolls vertically, or vertical scroll sometimes triggers page change.

### Pitfall 2: LazyVStack Pinned Header + TabView Height
**What goes wrong:** The pinned section header works, but the TabView below it doesn't size correctly because TabView wants to fill available space.
**Why it happens:** TabView inside LazyVStack doesn't have an intrinsic height.
**How to avoid:** Give the TabView an explicit `.frame(height:)` based on device height minus the header, or use `GeometryReader` to calculate remaining space. Alternatively, consider making the section content a direct child of the LazyVStack rather than using TabView for paging.
**Warning signs:** Content gets clipped, or infinite height layout warnings in console.

### Pitfall 3: Welcome Card @AppStorage Encoding for Set<String>
**What goes wrong:** @AppStorage doesn't natively support `Set<String>`. Trying to store it crashes or silently fails.
**Why it happens:** @AppStorage only supports basic types (String, Int, Bool, Double, Data, URL).
**How to avoid:** Use a comma-separated String in @AppStorage and parse it, or store the welcome-shown flag directly on the Subscription model in SubscriptionStore (which already persists via UserDefaults JSON encoding).
**Warning signs:** Welcome card shows every time despite being "dismissed."

### Pitfall 4: Segmented Control Not Updating TabView (or Vice Versa)
**What goes wrong:** Tapping the Picker changes the segment but doesn't swipe the TabView, or swiping doesn't update the Picker.
**Why it happens:** The Picker and TabView are bound to different state variables, or the binding is not truly shared.
**How to avoid:** Both Picker and TabView must bind to the exact same `@State` or `@Bindable` property on the view model. Use a single `selectedSection` property.
**Warning signs:** Visual desync between which segment is highlighted and which page is shown.

### Pitfall 5: communityDetail Route Uses String ID but Community.id is UUID
**What goes wrong:** The existing `HubsRoute.communityDetail(id: String)` passes a String, but Community.id is UUID. Lookup fails silently.
**Why it happens:** Inconsistency inherited from Phase 3 where communityPreview also uses String.
**How to avoid:** Use the same pattern as CommunityPreviewView: `store.communities.first(where: { $0.id.uuidString == communityID })`. This is the established pattern.
**Warning signs:** Community hub shows loading spinner forever or crashes on force unwrap.

### Pitfall 6: Post-Confetti Navigation Chain
**What goes wrong:** After confetti celebration dismiss, the user needs to land on the community hub. But the payment sheet is inside CommunityPreviewView which is a pushed navigation destination. Dismissing the sheet AND navigating forward requires careful sequencing.
**Why it happens:** Sheet dismissal and NavigationStack path manipulation happening simultaneously.
**How to avoid:** The `onSubscriptionComplete` callback in TiersBottomSheet already dismisses and pops. For Phase 5, modify this to navigate to `.communityDetail(id:)` instead of just dismissing. Use the sequenced dismissal chain pattern (300ms delay) established in Phase 4.
**Warning signs:** Double-dismiss animation glitch, or user lands back on discovery instead of community hub.

## Code Examples

### Community Hub View (Main Container)
```swift
// Source: Project patterns from CommunityPreviewView + native APIs
struct CommunityHubView: View {
    let communityID: String

    @Environment(CommunityStore.self) private var store
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @State private var viewModel: CommunityHubViewModel?
    @State private var showWelcome = false

    var body: some View {
        Group {
            if let viewModel {
                hubContent(viewModel: viewModel)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(BlossomTheme.background)
        .onAppear {
            if viewModel == nil,
               let community = store.communities.first(where: { $0.id.uuidString == communityID }) {
                viewModel = CommunityHubViewModel(community: community)
            }
        }
        .overlay {
            if showWelcome, let vm = viewModel {
                WelcomeOverlayView(community: vm.community, tierName: tierName) {
                    withAnimation { showWelcome = false }
                }
            }
        }
    }

    private var tierName: String {
        guard let id = UUID(uuidString: communityID),
              let sub = subscriptionStore.session.subscriptions[id] else { return "" }
        return sub.tierName
    }
}
```

### Link-Tree Row (iOS Settings Style)
```swift
// Source: iOS Settings pattern, project conventions
struct CommunityLinkTreeRow: View {
    let icon: String
    let title: String
    let count: Int?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(BlossomTheme.violet)
                    .frame(width: 28, height: 28)

                Text(title)
                    .font(BlossomFont.body)
                    .foregroundStyle(BlossomTheme.primaryText)

                Spacer()

                if let count {
                    Text("\(count)")
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(BlossomTheme.secondaryText)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
    }
}
```

### Tier Badge Display
```swift
// Source: Existing TagView component with .subscribed style
// Near community name on landing page:
if let sub = subscriptionStore.session.subscriptions[community.id] {
    TagView(sub.tierName, style: .tier)
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| GeometryReader for sticky headers | LazyVStack(pinnedViews:) | iOS 14 | Simpler, native sticky behavior |
| NavigationView | NavigationStack (value-based routing) | iOS 16 | Already adopted in project |
| @ObservedObject view models | @Observable @MainActor classes | iOS 17 | Already adopted in project |
| UIPageViewController | TabView(.page) | iOS 14 | Pure SwiftUI page swiping |
| .foregroundColor() | .foregroundStyle() | iOS 15 | Already adopted in project |
| Custom preference key scroll tracking | .visualEffect { } | iOS 17 | Already used for parallax |

## Open Questions

1. **Nested ScrollView + TabView Height Management**
   - What we know: TabView(.page) inside a ScrollView with LazyVStack can cause height issues
   - What's unclear: Whether the content inside each page will size correctly without an explicit frame
   - Recommendation: Start with explicit frame height (screen height - header height) and iterate. If problematic, consider an alternative architecture where section switching replaces the entire scroll content rather than being nested.

2. **Post-Confetti Navigation to Community Hub**
   - What we know: Currently `onSubscriptionComplete` dismisses the preview view. Phase 5 needs it to navigate to community hub instead.
   - What's unclear: Exact sequencing needed -- does the sheet dismiss, then navigation path gets a `.communityDetail` push, or does the preview stay and morph?
   - Recommendation: Push `.communityDetail(id:)` onto the NavigationStack path after sheet dismissal, using the established 300ms delay pattern.

3. **Welcome Card First-Visit Persistence**
   - What we know: @AppStorage supports basic types only. SubscriptionStore already persists to UserDefaults.
   - What's unclear: Best location for "hasSeenWelcome" flag
   - Recommendation: Add a `hasSeenWelcome: Bool` field to the `Subscription` struct in SubscriptionStore. This naturally scopes the flag per-community per-subscription and persists via existing JSON encoding. Re-subscribing after cancellation would correctly show the welcome card again.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Xcode XCTest (bundled with Xcode) |
| Config file | BlossomHubs.xcodeproj test target (if exists, otherwise Wave 0) |
| Quick run command | `xcodebuild test -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BlossomHubsTests` |
| Full suite command | `xcodebuild test -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16'` |

### Phase Requirements to Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| HUB-01 | Landing page displays logo, banner, title, description for all communities | unit | Test CommunityHubViewModel initializes with correct community data | No -- Wave 0 |
| HUB-02 | Link-tree shows only sections with content, tapping switches section | unit | Test availableSections computed property filters correctly per community data | No -- Wave 0 |
| HUB-08 | Segmented control switches between sections without leaving community | unit | Test selectedSection binding drives both Picker and pager state | No -- Wave 0 |

### Sampling Rate
- **Per task commit:** Build succeeds, preview renders
- **Per wave merge:** All community mock data renders correctly on landing page
- **Phase gate:** All 6 mock communities display correct landing pages with data-driven sections

### Wave 0 Gaps
- [ ] `BlossomHubsTests/CommunityHubViewModelTests.swift` -- covers HUB-01, HUB-02, HUB-08
- [ ] Test target setup in Xcode project if not already present
- [ ] Verify CommunityHubViewModel.availableSections returns correct sections for each mock community

## Sources

### Primary (HIGH confidence)
- Project codebase: CommunityPreviewView.swift -- parallax banner with .visualEffect, overlapping avatar pattern
- Project codebase: HubsView.swift -- NavigationStack routing, .communityDetail EmptyView placeholder
- Project codebase: Community.swift -- model with posts, threads, faqEntries arrays
- Project codebase: SubscriptionStore.swift -- subscription lookup, tier info
- Project codebase: TagView.swift -- .subscribed style for tier badge
- Project codebase: ConfettiCelebrationView.swift -- overlay pattern, delayed button reveal
- [Apple PinnedScrollableViews docs](https://developer.apple.com/documentation/swiftui/pinnedscrollableviews) -- native sticky section headers
- swiftui-pro skill references -- navigation, views, data, performance, design rules

### Secondary (MEDIUM confidence)
- [Hacking with Swift: TabView page style](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-scrolling-pages-of-content-using-tabviewstyle) -- TabView paging pattern
- [Hacking with Swift: Segmented control](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-segmented-control-and-read-values-from-it) -- Picker segmented style
- [YoSwift: PinnedScrollableViews](https://yoswift.dev/swiftui/pinnedScrollableViews/) -- sticky header implementation

### Tertiary (LOW confidence)
- [Medium: Custom scroll effects Jan 2026](https://21zerixpm.medium.com/custom-scroll-effects-in-swiftui-parallax-sticky-headers-and-more-3d703571fe76) -- parallax and sticky patterns (not verified against official docs)

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- all native SwiftUI APIs, no third-party dependencies, patterns already proven in project
- Architecture: HIGH -- follows established project patterns (per-feature folders, @MainActor @Observable view models, @State optional lazy init)
- Pitfalls: HIGH -- nested scroll/paging and navigation chain issues are well-documented; specific mitigations identified from project history

**Research date:** 2026-03-13
**Valid until:** 2026-04-13 (stable -- all native iOS APIs, no fast-moving dependencies)

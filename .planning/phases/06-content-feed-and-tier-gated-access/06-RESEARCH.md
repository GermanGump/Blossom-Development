# Phase 6: Content Feed and Tier-Gated Access - Research

**Researched:** 2026-03-14
**Domain:** SwiftUI content feed, investing-native post cards, tier-gated access, YouTube deep linking, collection filtering
**Confidence:** HIGH

## Summary

Phase 6 replaces the placeholder EmptyStateView in CommunitySectionPager's `.posts` and `.videos` cases with a fully functional content feed. The feed renders three distinct post card types (text, trade highlight, YouTube link), applies tier-based content gating with blurred locked overlays, and provides dropdown collection filtering. All data models (Post, PostType, Community.posts), reusable components (LockedContentOverlay, TagView, AvatarView, BlossomCard), and integration points (CommunitySectionPager, SubscriptionStore, TiersBottomSheet) are already built and well-tested through prior phases.

The primary technical challenge is not infrastructure but visual design -- creating three visually distinct card types that feel investing-native (Bloomberg-lite trade highlights, YouTube-recognizable video cards) while maintaining the existing Blossom design language. The tier access check is straightforward (compare post.requiredTierIndex against user tier index in community.tiers array). YouTube deep linking uses a single UIApplication.shared.open() call.

**Primary recommendation:** Build a ContentFeedView with a ContentFeedViewModel that owns filtering/sorting state, three dedicated card subviews (TextPostCard, TradeHighlightCard, YouTubeLinkCard), a static ticker price lookup table, and wire into CommunitySectionPager -- reusing existing LockedContentOverlay, TagView, AvatarView, and TiersBottomSheet without modification.

<user_constraints>

## User Constraints (from CONTEXT.md)

### Locked Decisions
- **Trade highlight cards:** Bloomberg-lite investing card style with stock ticker price/change data. Each ticker shows mock price and percentage change (e.g., "$AAPL $182.50 +2.3%"). Price data from static lookup table keyed by ticker symbol. Stock ticker tags use existing TagView(.stock) in orange. Visually distinct from text posts via ticker + price metrics row.
- **YouTube link cards:** Rich link preview card with placeholder thumbnail + video title + YouTube icon + "Tap to watch on YouTube" subtitle. YouTube thumbnail placeholder uses dark gradient with YouTube-red play button overlay. Tapping opens YouTube app via URL deep link (or Safari fallback). Post body text appears above the embedded link card.
- **Text posts:** Standard card with author avatar, name, timestamp, post body. Long content truncated to 3-4 lines with "Read more" tap to expand inline.
- **Locked content treatment:** Blurred card preview approach -- show full card layout (author, timestamp, type indicator, ticker tags if trade highlight) but blur the body content. Uses existing LockedContentOverlay component pattern. Upgrade prompt names specific required tier. Locked posts interspersed chronologically (Patreon pattern). Tapping "Upgrade" opens existing TiersBottomSheet.
- **Collection filtering UX:** Dropdown picker in feed header (e.g., "Filter: All Posts"). Tap to see collection list derived from community's posts. "All" selected by default. Collections do NOT appear as tags on individual post cards. Posts without a collection always show regardless of filter (or only under "All").

### Claude's Discretion
- Exact mock price values per ticker symbol in the lookup table
- Post card spacing, padding, and internal layout details
- YouTube thumbnail gradient exact colors and play button styling
- "Read more" expansion animation (inline expand vs sheet)
- Dropdown picker styling and placement relative to segmented control
- Author avatar size and timestamp format on post cards
- Like/comment count display (mock engagement numbers)
- Feed scroll performance approach (LazyVStack vs List)

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope

</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| HUB-03 | Content feed showing creator posts chronologically -- supports text, trade highlights, and YouTube video links | ContentFeedView with LazyVStack, three card types, chronological sort by publishedAt |
| HUB-04 | Investing-native content types: trade highlight cards with stock ticker tags, portfolio summary posts matching Blossom's Home feed visual patterns | TradeHighlightCard with TagView(.stock) ticker tags, static price lookup table, Bloomberg-lite metrics row |
| HUB-05 | YouTube video links that open the YouTube app on tap (URL deep link, no inline player) | YouTubeLinkCard with UIApplication.shared.open(url) deep link, Safari fallback via canOpenURL check |
| HUB-06 | Tier-gated content access -- lower-tier subscribers see locked post previews with an upgrade prompt | LockedContentOverlay wrapping card content, tier index comparison via SubscriptionStore, TiersBottomSheet presentation |
| HUB-07 | Collections / content organization -- named categories that users can browse by topic | Dropdown Picker in feed header, collection extraction from posts, filter state in ContentFeedViewModel |

</phase_requirements>

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| SwiftUI | iOS 26 | All UI rendering | Project target, already established |
| @Observable / @MainActor | Swift 6.2 | ViewModel pattern | Project convention from Phase 1 |

### Supporting (all existing -- no new dependencies)
| Component | Location | Purpose | Used For |
|-----------|----------|---------|----------|
| LockedContentOverlay | Core/Components/ | Blur + lock + upgrade prompt | HUB-06 locked posts |
| TagView(.stock) | Core/Components/ | Orange stock ticker tags | HUB-04 trade highlight tickers |
| BlossomCard modifier | Core/Components/ | Card styling with shadows | All post cards |
| AvatarView | Core/Components/ | Creator avatar with verified badge | Post card author row |
| BlossomTheme | Core/Theme/ | Color tokens | All new views |
| BlossomFont | Core/Theme/ | Typography tokens | All new views |
| TiersBottomSheet | Features/Hubs/Preview/ | Tier upgrade flow | Locked content upgrade action |
| SubscriptionStore | Models/ | User subscription state | Tier access checks |
| CommunityStore | Models/ | Community + post data | Feed data source |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| LazyVStack | List | List adds default separators, row styling, and swipe actions that fight the custom card design -- LazyVStack gives full control |
| Static ticker lookup | Post model field | Lookup table keeps Post model lean, provides consistent prices across app, matches user decision |
| Inline "Read more" expand | Sheet detail view | Inline keeps user in feed context, avoids navigation complexity, matches user decision |

**Installation:**
No new dependencies required. All components exist in the project.

## Architecture Patterns

### Recommended Project Structure
```
BlossomHubs/Features/Hubs/Feed/
    ContentFeedView.swift          # Main feed view (LazyVStack of cards)
    ContentFeedViewModel.swift     # @MainActor @Observable -- filtering, sorting, tier access
    PostCardView.swift             # Router view dispatching to card type
    TextPostCard.swift             # Text post card layout
    TradeHighlightCard.swift       # Bloomberg-lite trade card with ticker metrics
    YouTubeLinkCard.swift          # YouTube preview card with deep link
    CollectionFilterPicker.swift   # Dropdown picker for collection filtering
    TickerPriceLookup.swift        # Static ticker -> (price, change%) lookup table
```

### Pattern 1: ViewModel with @MainActor @Observable
**What:** ContentFeedViewModel follows the established project pattern -- @MainActor @Observable class with @Environment store access delegated to the view.
**When to use:** Every new feature screen in this project.
**Example:**
```swift
@MainActor
@Observable
final class ContentFeedViewModel {
    let community: Community
    var selectedCollection: String? = nil  // nil = "All"

    var collections: [String] {
        let names = Set(community.posts.compactMap { $0.collection })
        return names.sorted()
    }

    var filteredPosts: [Post] {
        let sorted = community.posts.sorted { $0.publishedAt > $1.publishedAt }
        guard let collection = selectedCollection else { return sorted }
        return sorted.filter { $0.collection == collection }
    }

    func canAccess(post: Post, userTierIndex: Int?) -> Bool {
        guard let userIndex = userTierIndex else { return false }
        return post.requiredTierIndex <= userIndex
    }

    func tierName(for requiredIndex: Int) -> String {
        guard requiredIndex < community.tiers.count else { return "Premium" }
        return community.tiers[requiredIndex].name
    }

    init(community: Community) {
        self.community = community
    }
}
```

### Pattern 2: Tier Access Check
**What:** Compare post.requiredTierIndex against the user's tier index in the community tiers array.
**When to use:** Every post card render to determine locked/unlocked state.
**Example:**
```swift
// In the view, with @Environment access:
func userTierIndex(community: Community, subscriptionStore: SubscriptionStore) -> Int? {
    guard let tierID = subscriptionStore.currentTier(for: community.id) else {
        return nil  // Not subscribed -- all locked
    }
    return community.tiers.firstIndex(where: { $0.id == tierID })
}
```

### Pattern 3: CommunitySectionPager Integration
**What:** Replace EmptyStateView placeholders in CommunitySectionPager with actual ContentFeedView.
**When to use:** Phase 6 integration point.
**Example:**
```swift
// In CommunitySectionPager.sectionPage(for:)
case .posts:
    ContentFeedView(community: community)
case .videos:
    ContentFeedView(community: community, filterToVideos: true)
```
Note: The `.videos` section can reuse ContentFeedView filtered to youtubeLink posts only, avoiding duplicate view code.

### Pattern 4: YouTube Deep Link
**What:** Open YouTube app via URL scheme, fall back to Safari.
**When to use:** YouTubeLinkCard tap action.
**Example:**
```swift
func openYouTube(urlString: String) {
    guard let url = URL(string: urlString) else { return }
    UIApplication.shared.open(url)
    // UIApplication.shared.open already handles fallback to Safari
}
```

### Pattern 5: Static Ticker Price Lookup
**What:** Dictionary mapping ticker symbols to mock price data, providing consistent values app-wide.
**When to use:** Trade highlight card rendering.
**Example:**
```swift
enum TickerPriceLookup {
    struct TickerData {
        let price: String
        let change: String
        let isPositive: Bool
    }

    static let data: [String: TickerData] = [
        "$AAPL": TickerData(price: "$182.50", change: "+2.3%", isPositive: true),
        "$RY.TO": TickerData(price: "$145.20", change: "+1.1%", isPositive: true),
        "$SHOP.TO": TickerData(price: "$98.75", change: "-0.8%", isPositive: false),
        "$CNQ.TO": TickerData(price: "$78.30", change: "-1.2%", isPositive: false),
        "$FTS.TO": TickerData(price: "$58.90", change: "+0.6%", isPositive: true),
        // ... all tickers used in mock data
    ]

    static func lookup(_ ticker: String) -> TickerData {
        data[ticker] ?? TickerData(price: "--", change: "--", isPositive: true)
    }
}
```

### Pattern 6: Locked Content Card Wrapping
**What:** Show card metadata (author, timestamp, type indicator, ticker tags) clearly, but blur body content using LockedContentOverlay.
**When to use:** Posts where requiredTierIndex > userTierIndex.
**Example:**
```swift
// Per-card approach -- wrap only the content body, not the full card
VStack(alignment: .leading, spacing: 8) {
    // Always visible: author row
    PostAuthorRow(community: community, post: post)

    if canAccess {
        // Full content visible
        postBody
    } else {
        // Blurred body with lock overlay
        LockedContentOverlay(
            tierName: viewModel.tierName(for: post.requiredTierIndex),
            onUpgrade: { showTierSheet = true }
        ) {
            postBody
        }
    }
}
```

### Anti-Patterns to Avoid
- **Putting filter state in CommunityHubViewModel:** Feed filtering is feed-specific concern. ContentFeedViewModel should own its own selectedCollection state.
- **Creating separate video feed view:** The .videos section is just the posts feed filtered to youtubeLink type. Reuse ContentFeedView with a filter parameter.
- **Modifying LockedContentOverlay component:** It already does exactly what is needed (blur + overlay + tier name + upgrade button). Wrap card content with it, do not fork it.
- **Adding price fields to Post model:** User decision is explicit -- static lookup table keyed by ticker symbol. Post model stays lean.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Locked content blur | Custom blur + overlay | LockedContentOverlay | Already built with correct blur radius, opacity, lock icon, tier-specific upgrade text |
| Stock ticker tags | Custom styled text | TagView(.stock) | Orange capsule style already matches Blossom brand guidelines |
| Card styling | Custom shadows/corners | .blossomCard() modifier | Consistent card surface, border, shadow across all app cards |
| Creator avatar display | Custom image + badge | AvatarView(preset:) | Handles ring, verified badge, ambassador bolt, all sizes |
| Tier upgrade flow | Custom upgrade sheet | TiersBottomSheet(community:) | Full tier listing with pricing and subscribe action already working |
| URL opening | Custom URL handler | UIApplication.shared.open(url) | System handles YouTube app detection, Safari fallback, universal links |

**Key insight:** Phase 6 is almost entirely new views -- but nearly zero new infrastructure. Every underlying capability (data models, access checks, overlays, navigation) was established in Phases 2-5. The work is card layout and visual design.

## Common Pitfalls

### Pitfall 1: LockedContentOverlay Sizing in Cards
**What goes wrong:** LockedContentOverlay uses .ignoresSafeArea() internally which can expand beyond card bounds when nested inside a card.
**Why it happens:** The overlay was designed for full-screen use (Phase 2 preview shows it over full card list), but here it wraps individual card content.
**How to avoid:** Apply .clipShape(RoundedRectangle(...)) to the card container AFTER the overlay, or use a simplified per-card lock overlay that omits .ignoresSafeArea(). If existing component does not clip well at card-level, create a PostLockedOverlay variant that omits ignoresSafeArea.
**Warning signs:** Lock overlay bleeds outside card boundaries in preview.

### Pitfall 2: Paged TabView Height with Variable Content
**What goes wrong:** CommunitySectionPager uses .tabViewStyle(.page) with .frame(minHeight: 400). If the feed content is taller than 400pt, it gets clipped or scroll-within-scroll conflicts.
**Why it happens:** Paged TabView does not intrinsically size to its content. The 400pt minimum was a placeholder value.
**How to avoid:** Either increase minHeight significantly (e.g., UIScreen.main.bounds.height), use GeometryReader to size dynamically, or restructure so the feed is not inside a paged TabView but rather directly conditionally rendered based on selectedSection.
**Warning signs:** Feed content clips at bottom, scroll bounce feels wrong.

### Pitfall 3: Scroll-within-Scroll (LazyVStack in ScrollView in TabView in ScrollView)
**What goes wrong:** CommunityHubView already has a ScrollView > LazyVStack. The pager is inside that. If ContentFeedView also uses ScrollView, nested scrolling creates janky UX.
**Why it happens:** Four nested scrollable containers -- outer ScrollView, LazyVStack, TabView pager, inner feed ScrollView.
**How to avoid:** ContentFeedView should NOT have its own ScrollView. It should be a plain VStack/LazyVStack that participates in the outer scroll context. OR restructure CommunityHubView so that when a section is selected, the pager replaces the outer ScrollView content entirely.
**Warning signs:** Bouncy scroll, content not reaching bottom, pull-to-refresh not working.

### Pitfall 4: Collection Filter Including Posts Without Collection
**What goes wrong:** User decision states "Posts without a collection always show regardless of filter (or only under 'All')". Easy to filter them out when a collection is selected.
**Why it happens:** Simple filter `post.collection == selectedCollection` excludes nil-collection posts.
**How to avoid:** Filter logic: `selectedCollection == nil || post.collection == selectedCollection || post.collection == nil` (if showing always) or just `selectedCollection == nil || post.collection == selectedCollection` (if only under All). Pick one and be consistent.
**Warning signs:** Posts disappear when filtering that should remain visible.

### Pitfall 5: Tier Index Off-by-One
**What goes wrong:** requiredTierIndex 0 means the lowest/free tier. If userTierIndex is nil (not subscribed), all posts should be locked. If user is on tier index 0, they can see requiredTierIndex 0 posts but not 1+.
**How to avoid:** Clear logic: `guard let userIndex else { return false }; return post.requiredTierIndex <= userIndex`. Never treat nil as 0.
**Warning signs:** Non-subscribers see free-tier content as unlocked (should be locked per CONTEXT.md: "Non-subscribers see ALL posts as locked").

## Code Examples

### PostAuthorRow (shared across all card types)
```swift
struct PostAuthorRow: View {
    let community: Community
    let post: Post

    var body: some View {
        HStack(spacing: 10) {
            AvatarView(
                imageName: community.creator.profileImageName,
                preset: .small,
                showVerifiedBadge: community.creator.isVerified
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(community.creator.name)
                    .font(BlossomFont.subhead)
                    .foregroundColor(BlossomTheme.primaryText)
                Text(post.publishedAt.formatted(.relative(presentation: .named)))
                    .font(BlossomFont.caption)
                    .foregroundColor(BlossomTheme.secondaryText)
            }

            Spacer()
        }
    }
}
```

### TradeHighlightCard ticker metrics row
```swift
// Ticker metrics row for trade highlight cards
HStack(spacing: 8) {
    ForEach(post.stockTickers, id: \.self) { ticker in
        let data = TickerPriceLookup.lookup(ticker)
        HStack(spacing: 4) {
            Text(ticker)
                .font(BlossomFont.caption)
                .foregroundColor(BlossomTheme.orange)
                .fontWeight(.semibold)
            Text(data.price)
                .font(BlossomFont.caption)
                .foregroundColor(BlossomTheme.primaryText)
            Text(data.change)
                .font(BlossomFont.caption)
                .foregroundColor(data.isPositive ? .green : .red)
        }
    }
}
```

### YouTubeLinkCard thumbnail placeholder
```swift
// YouTube thumbnail placeholder with dark gradient and red play button
ZStack {
    RoundedRectangle(cornerRadius: 10)
        .fill(
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .frame(height: 180)

    // YouTube-red play button
    Circle()
        .fill(Color.red)
        .frame(width: 56, height: 56)
        .overlay(
            Image(systemName: "play.fill")
                .font(.system(size: 22))
                .foregroundColor(.white)
                .offset(x: 2)  // Visual centering for play icon
        )
}
```

### Collection dropdown picker
```swift
// Feed header with collection filter
HStack {
    Menu {
        Button("All Posts") { viewModel.selectedCollection = nil }
        Divider()
        ForEach(viewModel.collections, id: \.self) { collection in
            Button(collection) { viewModel.selectedCollection = collection }
        }
    } label: {
        HStack(spacing: 4) {
            Text("Filter: \(viewModel.selectedCollection ?? "All Posts")")
                .font(BlossomFont.subhead)
                .foregroundColor(BlossomTheme.primaryText)
            Image(systemName: "chevron.down")
                .font(.system(size: 12))
                .foregroundColor(BlossomTheme.secondaryText)
        }
    }
    Spacer()
}
.padding(.horizontal, 16)
.padding(.vertical, 8)
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| List with .listStyle(.plain) | LazyVStack in ScrollView | SwiftUI convention since iOS 15+ | Full card layout control, no default separators or row padding |
| .onTapGesture + openURL | UIApplication.shared.open(url) | Stable since iOS 2 | Handles universal links, app deep links, Safari fallback automatically |
| .blur() on individual views | LockedContentOverlay wrapper | Project Phase 2 | Consistent locked appearance across all locked content |

**Deprecated/outdated:**
- UIApplication.shared.windows: Deprecated -- project uses connectedScenes (decided in Phase 1)
- NavigationLink(destination:): Project uses NavigationLink(value:) with value-based routing

## Open Questions

1. **Scroll nesting with paged TabView**
   - What we know: CommunityHubView uses ScrollView > LazyVStack > Section > CommunitySectionPager (paged TabView). Adding a scrollable feed inside the pager creates nested scroll conflicts.
   - What's unclear: Whether a LazyVStack without its own ScrollView inside the paged TabView will size correctly and participate in the outer scroll.
   - Recommendation: Test with a plain LazyVStack first. If sizing fails, restructure to conditionally show feed content directly in the outer LazyVStack based on selectedSection, bypassing the paged TabView for posts.

2. **LockedContentOverlay at card level**
   - What we know: LockedContentOverlay was built with .ignoresSafeArea() for full-screen overlay use.
   - What's unclear: Whether it clips properly when wrapped around a small card body (not full screen).
   - Recommendation: Test in preview. If ignoresSafeArea causes bleed, create a lightweight PostLockedOverlay that omits that modifier, or clip the card container.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Xcode Previews + manual Simulator verification |
| Config file | none -- SwiftUI preview-based validation |
| Quick run command | Build and run in Simulator (Cmd+R) |
| Full suite command | Full Simulator walkthrough: subscribe -> navigate to Posts tab -> verify all 3 card types -> test locked content -> test collection filter -> test YouTube deep link |

### Phase Requirements -> Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| HUB-03 | Feed shows posts chronologically with 3 types | manual | Simulator: navigate to Posts section, verify card types render | No -- Wave 0 |
| HUB-04 | Trade highlight cards show ticker tags + price metrics | manual | Simulator: find trade highlight post, verify orange ticker tags and price row | No -- Wave 0 |
| HUB-05 | YouTube card tap opens YouTube/Safari | manual | Simulator: tap YouTube card, verify external app opens | No -- Wave 0 |
| HUB-06 | Lower-tier users see blurred locked posts with upgrade prompt | manual | Simulator: subscribe at lowest tier, verify higher-tier posts show locked overlay | No -- Wave 0 |
| HUB-07 | Collection filter narrows feed by category | manual | Simulator: tap filter dropdown, select collection, verify feed filters | No -- Wave 0 |

### Sampling Rate
- **Per task commit:** Xcode build succeeds (Cmd+B), SwiftUI previews render without error
- **Per wave merge:** Full Simulator walkthrough covering all 5 requirements
- **Phase gate:** All 5 HUB requirements verified in Simulator before /gsd:verify-work

### Wave 0 Gaps
- None -- this is a UI-only prototype with manual verification. No automated test infrastructure needed beyond Xcode build success.

## Sources

### Primary (HIGH confidence)
- **Codebase inspection** -- All files read directly from project: Community.swift (Post model with PostType enum, requiredTierIndex, collection, youtubeURL), LockedContentOverlay.swift (blur + lock overlay), TagView.swift (stock/tier tag styles), SubscriptionStore.swift (tier access via currentTier(for:)), CommunitySectionPager.swift (integration point with EmptyStateView placeholders), CommunityHubView.swift (scroll structure), CommunityStore.swift (mock data with all three post types and collections)
- **CONTEXT.md** -- User decisions locking trade highlight, YouTube, text card designs, locked content treatment, and collection filter UX

### Secondary (MEDIUM confidence)
- UIApplication.shared.open() behavior for YouTube deep linking -- well-documented Apple API, handles universal links and Safari fallback

### Tertiary (LOW confidence)
- None -- all findings verified against codebase

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- no new dependencies, all components exist and are verified in codebase
- Architecture: HIGH -- follows established project patterns (MVVM with @Observable, @MainActor, @Environment injection)
- Pitfalls: HIGH -- identified through direct codebase analysis (scroll nesting, overlay sizing, tier index logic)

**Research date:** 2026-03-14
**Valid until:** 2026-04-14 (stable -- no external dependencies or fast-moving libraries)

# Phase 6: Content Feed and Tier-Gated Access - Context

**Gathered:** 2026-03-14
**Status:** Ready for planning

<domain>
## Phase Boundary

A subscribed user can browse the creator's content feed with investing-native post types (text, trade highlights, YouTube links), see locked-content prompts for posts above their tier, and filter content by named collection. Requirements: HUB-03, HUB-04, HUB-05, HUB-06, HUB-07.

</domain>

<decisions>
## Implementation Decisions

### Post card design — trade highlights
- Bloomberg-lite investing card style with stock ticker price/change data
- Each ticker in a trade highlight shows a mock price and percentage change (e.g., "$AAPL $182.50 +2.3%")
- Price data generated from a static lookup table keyed by ticker symbol — consistent across app, no extra fields on Post model
- Stock ticker tags displayed using existing TagView(.stock) in orange
- Trade highlight cards visually distinct from text posts via the ticker + price metrics row

### Post card design — YouTube link cards
- Rich link preview card embedded within the post: placeholder thumbnail + video title + YouTube icon + "Tap to watch on YouTube" subtitle
- YouTube thumbnail placeholder uses a dark gradient with YouTube-red play button overlay (not community gradient) — makes video cards instantly recognizable
- Tapping the card opens YouTube app via URL deep link (or Safari fallback)
- Post body text appears above the embedded link card

### Post card design — text posts
- Standard card with author avatar, name, timestamp, post body
- Long content truncated to 3-4 lines with "Read more" tap to expand inline
- Keeps the feed scannable when creators write longer posts

### Locked content treatment
- Blurred card preview approach — show full card layout (author, timestamp, type indicator, ticker tags if trade highlight) but blur the body content
- Uses existing LockedContentOverlay component pattern (blur + semi-transparent overlay + lock icon + upgrade prompt)
- Upgrade prompt names the specific required tier (e.g., "Upgrade to Pro")
- Locked posts interspersed chronologically in the feed (Patreon pattern) — creates FOMO by showing gaps in accessible content
- Tapping "Upgrade" opens the existing TiersBottomSheet — reuses Phase 4 infrastructure

### Collection filtering UX
- Dropdown picker in the feed header (e.g., "Filter: All Posts ▼")
- Tap to see collection list derived from community's posts
- "All" selected by default — filtering narrows to posts with matching collection
- Collections do NOT appear as tags on individual post cards — keeps cards clean
- Posts without a collection always show regardless of filter (or only under "All")

### Claude's Discretion
- Exact mock price values per ticker symbol in the lookup table
- Post card spacing, padding, and internal layout details
- YouTube thumbnail gradient exact colors and play button styling
- "Read more" expansion animation (inline expand vs sheet)
- Dropdown picker styling and placement relative to segmented control
- Author avatar size and timestamp format on post cards
- Like/comment count display (mock engagement numbers)
- Feed scroll performance approach (LazyVStack vs List)

</decisions>

<specifics>
## Specific Ideas

- Trade highlight cards should feel like a finance app — think Robinhood position cards or Bloomberg terminal lite
- YouTube cards with red play button are universally recognizable — don't reinvent that pattern
- Blurred locked content is the Patreon gold standard — teases enough to drive upgrades without giving away content
- Dropdown filter is cleaner than chip rows when there are many collections (some communities have 5+ categories)
- "Read more" keeps the feed dense and scannable — important for a content-first design philosophy

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- Post model: PostType enum (.text, .tradeHighlight, .youtubeLink), stockTickers [String], requiredTierIndex Int, collection String?, youtubeURL String?
- LockedContentOverlay: blur + semi-transparent overlay + lock icon + tier name + upgrade button — ready to wrap locked post cards
- TagView(.stock): orange ticker tags — use for stock symbols on trade highlight cards
- TagView(.tier): violet tier badge — use for tier indicator on locked posts
- BlossomCard modifier: card styling with shadows and rounded corners
- AvatarView: creator profile images with verified badge and size presets (.small, .medium)
- CommunitySectionPager: has EmptyStateView placeholder for .posts section — replace with actual feed
- CommunityHubViewModel: already has community reference and selectedSection state
- TiersBottomSheet: existing upgrade flow — present when user taps "Upgrade" on locked content

### Established Patterns
- @MainActor @Observable for view models
- @Environment for CommunityStore and SubscriptionStore injection
- SubscriptionStore.currentTier(for:) returns tier UUID — compare against community.tiers index for access check
- LazyVStack(pinnedViews: [.sectionHeaders]) for sticky headers (used in CommunityHubView)

### Integration Points
- CommunitySectionPager .posts case: replace EmptyStateView with ContentFeedView
- SubscriptionStore: check user tier index vs post.requiredTierIndex for lock/unlock
- CommunityStore: community.posts array provides all posts for the feed
- Post.youtubeURL: open via UIApplication.shared.open() for YouTube deep link
- TiersBottomSheet: present on upgrade tap from locked post overlay

### Tier Access Pattern
- Post requires: requiredTierIndex (0 = free/lowest, 1 = first paid, 2 = second paid, etc.)
- User has: tierID UUID from SubscriptionStore.currentTier(for:)
- Access check: find tierID index in community.tiers array, compare post.requiredTierIndex <= userTierIndex
- Non-subscribers see ALL posts as locked (no tier index to compare)

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 06-content-feed-and-tier-gated-access*
*Context gathered: 2026-03-14*

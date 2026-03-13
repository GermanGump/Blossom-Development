# Phase 5: Community Hub and Navigation Structure - Context

**Gathered:** 2026-03-13
**Status:** Ready for planning

<domain>
## Phase Boundary

A subscribed user can navigate the inside of a community via a clear landing page and section-switching controls — the structural skeleton that all content and engagement screens attach to. Requirements: HUB-01, HUB-02, HUB-08.

</domain>

<decisions>
## Implementation Decisions

### Landing page layout
- Full-width banner image at top with parallax scroll effect (reuse CommunityPreviewView parallax pattern)
- Community logo overlaps bottom edge of banner (half on banner, half below — Discord/Facebook style)
- Below logo: community name, 1-2 sentence description, member count
- User's current subscription tier shown as a small badge near the community name (e.g., "Premium" in violet)
- Standard iOS back chevron + community name as nav bar title
- Banner images: use generated gradient/color-based placeholders per community (can swap real images later)
- Each community gets a unique placeholder gradient derived from its category or brand

### Link-tree navigation
- iOS settings-style list rows: SF Symbol icon, section label, right chevron
- Sections are data-driven — only show sections that have content in the Community model (e.g., skip Videos if no YouTube posts)
- Tapping a link-tree item switches to that section via the segmented control (not a new screen push)
- Section count badges: Claude's discretion on whether to show counts

### Section switching
- Native iOS segmented control (Picker) for switching between sections (Posts, Discussion, FAQ, Videos)
- Segmented control sticks below the header as user scrolls (sticky positioning)
- Swipe left/right between sections (TabView-style paging) AND tapping the control both work
- Default section on entering community: Claude's discretion (likely Landing/Home with link-tree)

### Post-subscription entry
- After confetti celebration, user sees a welcome overlay card before landing page
- Welcome card shows "Welcome to [Community Name]!" with tier name, and an "Explore" button
- Card has a subtle shake animation to prompt the user to tap
- Welcome card shown only on first entry per subscription — returning visits go straight to landing page
- Back navigation from community hub: Claude's discretion (standard back button is fine)

### Claude's Discretion
- Whether to show section content counts in link-tree rows
- Default tab when entering community (Landing vs Posts)
- Back navigation pattern (standard back vs custom)
- Exact gradient colors for placeholder banners
- Welcome card shake animation timing and intensity

</decisions>

<specifics>
## Specific Ideas

- Banner parallax should match the existing CommunityPreviewView pattern for consistency
- Logo overlapping banner edge like Discord server headers / Facebook group cover photos
- Welcome card with shake animation is similar to the confetti "tap to continue" pattern from Phase 4 — keep the interaction feel consistent
- Link-tree should feel like iOS Settings navigation rows (familiar, native)
- Segmented control + swipe paging is a well-known iOS pattern (like Apple's Stocks app detail view)

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- CommunityPreviewView: parallax banner implementation with GeometryReader — reuse for landing page banner
- AvatarView: creator profile images with verified badge — use for logo display
- BlossomCard modifier: card styling with shadows and rounded corners
- SectionHeader: reusable section header component
- TagView: can be used for tier badge display (TagStyle.subscribed exists)
- VerifiedBadge: creator verified badge component
- HubsRoute enum: already has `.communityDetail` case (currently EmptyView placeholder)

### Established Patterns
- @MainActor @Observable for view models (HubsDiscoveryViewModel pattern)
- NavigationStack with value-based routing via HubsRoute enum
- @Environment for CommunityStore and SubscriptionStore injection
- Per-tab NavigationStack isolation — community hub pushes onto Hubs tab stack

### Integration Points
- HubsRoute.communityDetail: replace EmptyView with CommunityHubView
- SubscriptionStore.isSubscribed(to:) and subscription(for:) for tier badge
- CommunityStore for community data (posts, threads, faqEntries)
- Post-confetti navigation from MockPaymentSheetView celebration → community hub

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 05-community-hub-and-navigation-structure*
*Context gathered: 2026-03-13*

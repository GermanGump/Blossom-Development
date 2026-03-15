# Phase 8: Creator Dashboard - Context

**Gathered:** 2026-03-15
**Status:** Ready for planning

<domain>
## Phase Boundary

A user identified as a community creator can access a dedicated dashboard to manage their community: edit details, define tiers with pricing and benefits, configure a permissions matrix, and publish content (text posts, trade highlights, YouTube links) with collection assignment and tier gating. The creator's verified badge displays throughout the app. Earnings view is Phase 9 — this phase adds a placeholder link only.

</domain>

<decisions>
## Implementation Decisions

### Creator Entry Point
- "Manage my Hub" card at the top of HubsDiscoveryView, above "My Hubs" section
- Only visible for users flagged as creators/ambassadors — hidden for regular subscribers
- Nick (the default session user) is a creator with a pre-existing community in mock data
- Tapping "Manage my Hub" pushes a dedicated CreatorDashboardView onto the NavigationStack
- Standard back navigation returns to subscriber discovery view
- If no hub exists yet, the card reads "Create Hub" (but for the demo, Nick's hub is pre-populated)

### Dashboard Layout
- Dashboard home shows two stat cards at top: subscriber count and estimated monthly revenue
- Below stats: card-style section links that push to sub-screens (not inline accordion)
- Section links: Edit Community, Manage Tiers, Permissions, Publish Content
- Earnings section shown as placeholder with "Coming soon" label (built in Phase 9)
- Edits to community details reflect immediately in subscriber-facing views via @Observable CommunityStore

### Tier & Permissions Editor
- Tier editor: list of tier cards, tapping opens a form sheet to edit name, price, and benefits
- "Add Tier" button at bottom when < 4 tiers exist
- Benefits editable as a list with add/remove capability
- Permissions matrix: visual grid — rows = sections (Posts, Discussions, FAQ Submit, Videos), columns = tiers
- Toggle switches at each intersection to grant/revoke access
- Changes update the permission model immediately

### Content Publishing
- Creator can publish all 3 post types: Text Post, Trade Highlight, YouTube Link
- Post type selection via segmented control or similar switcher at top of compose form
- Collection assignment via dropdown picker showing existing collections
- Tier gate assignment via dropdown picker showing the community's tiers
- Trade Highlight ticker entry: creator types `$AMD, $TSLA` — dollar-sign prefix parsed into ticker tags on publish
- YouTube Link post: text field for URL input
- Published post appears at top of content feed immediately (inserted into community.posts array)

### Claude's Discretion
- Exact form field styling and spacing
- How to handle the "isCreator" flag on UserSession (bool, or community ID reference)
- Whether to make Community model properties mutable or use a separate editing model
- Loading/success states for publish actions
- Empty state for dashboard sections

</decisions>

<specifics>
## Specific Ideas

- The creator entry point should feel like a natural fork in the Hubs area — "you're a subscriber AND a creator, here's your management tool"
- The "Manage my Hub" card should be visually distinct from subscriber community cards — it's a call-to-action, not a content card
- Ticker input uses `$` prefix convention (e.g., `$AMD`) matching investing app conventions
- Permissions grid should be scannable at a glance — which tiers get what

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `ForumComposeSheet`: Form pattern with NavigationStack, toolbar cancel/confirm, text fields — reuse for post compose and tier edit sheets
- `TiersBottomSheet`: Tier card display with expand/collapse — adapt card styling for tier editor list
- `BlossomCard`, `BlossomButton`, `TagView`: All themed components ready for dashboard UI
- `AvatarView`: Creator avatar display with verified badge
- `CommunityBannerView`: Banner display with parallax — reuse for community preview in edit screen
- `EmptyStateView`: Empty state placeholder component
- `CommunityLandingSection`: Link-tree style navigation pattern — reuse for dashboard section links

### Established Patterns
- `@MainActor @Observable` ViewModel pattern for all view models
- `@Environment(CommunityStore.self)` for accessing community data
- `@Environment(SubscriptionStore.self)` for accessing user session
- `NavigationLink(value:)` with `.navigationDestination(for:)` for push navigation
- `.sheet(item:)` for modal form presentation
- `Binding(get:set:)` for @Observable property binding

### Integration Points
- `CommunityStore`: Must become mutable — currently `let communities` needs to support editing
- `UserSession`: Needs `isCreator: Bool` and `creatorCommunityID: UUID?` fields
- `HubsDiscoveryView`: Add "Manage my Hub" card at top when user is creator
- `HubsRoute`: Add `.creatorDashboard` case for navigation
- `Community` model: Properties need to become `var` for editing (currently `let`)
- `Post` model: `addPost()` method needed on a ViewModel or CommunityStore

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 08-creator-dashboard*
*Context gathered: 2026-03-15*

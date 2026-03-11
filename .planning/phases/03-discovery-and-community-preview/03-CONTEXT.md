# Phase 3: Discovery and Community Preview - Context

**Gathered:** 2026-03-11
**Status:** Ready for planning

<domain>
## Phase Boundary

A subscriber opening the Communities tab can browse available communities, see enough information on each card to choose one, and view a full preview page with tier options that makes the value proposition clear before committing to subscribe. Covers splash intro, discovery browse, community preview page, and tier expansion sheet.

</domain>

<decisions>
## Implementation Decisions

### Splash/intro screen
- One-time intro — shown only on first visit, never again (persist state via @AppStorage or similar)
- Full-screen takeover — hides HubsTopNavBar entirely
- Logo animates briefly (scale up + fade), then auto-transitions to the discovery screen
- Adapts to both light and dark mode — light mode gets white background with light logo, dark mode gets dark background with dark logo variant
- After dismissal, user goes directly to discovery screen with stagger-fade entry animation

### Discovery screen layout
- Featured hero card at top for BD's community — larger card with "Popular" label badge
- Pulsating Blossom violet (#7361F7) glow/hue effect behind BD's hero card — draws attention
- BD's hero card shows category "Education & Swing Trading" and starting price "$29.99/mo"
- Remaining 5 communities displayed as vertical list of cards below the hero
- Each card shows: community logo, community name, creator profile photo (circular + verified badge), brief description, member count, category, and starting price (if fits cleanly in layout)
- Some cards may have slight style variations, but most use the default/vanilla card style
- Community order below hero: Claude picks sensible order based on mock data (e.g., member count)
- Stagger-fade-in entry animation when discovery screen first appears after splash — cards animate in from bottom sequentially for premium feel

### Search behavior
- HubsTopNavBar search bar is functional — filters communities by name/creator in real-time
- Search results appear in a dropdown overlay (quick results), not inline replacement of the browse view
- BD's hero card only shows on the main unfiltered page — in search results, BD appears as a normal result card
- When search is cleared/dismissed, full discovery layout returns with hero card

### Community preview page
- Patreon-style hero: full-width community banner image at top with creator avatar overlapping the bottom edge of the banner
- Parallax scroll effect on the banner (banner scrolls slower than content below)
- Content order below hero: value proposition tagline → creator bio (with photo + verified badge) → full description
- Grouped social proof section with variety — member count, row of member avatars, testimonial-style quote
- Blossom-styled back button for navigation (not just default NavigationStack back arrow)
- Sticky "View Tiers" CTA button at bottom — tiers are NOT inline on the page
- Tapping "View Tiers" presents a bottom sheet with tier cards

### Tier expansion (bottom sheet)
- Bottom sheet slides up when "View Tiers" is tapped
- Tier cards displayed as vertical stack inside the sheet
- One tier visually emphasized with "Most Popular" label — determined by mock data (not always the second tier)
- Price displayed subtly alongside the tier name (not large/prominent)
- Accordion expansion — tapping a tier card expands it inline to reveal benefits list, included content types, and monthly cost
- Only one tier expandable at a time — expanding one collapses the previously expanded tier
- Expanded tier shows a fully styled, tappable "Subscribe" button — button does nothing in Phase 3 (Phase 4 wires it up)
- Sheet dismissible by swiping down OR tapping outside

### Claude's Discretion
- Exact animation durations and easing curves for splash, stagger-fade, parallax, and accordion
- Hero card dimensions and layout proportions
- Social proof testimonial content and member avatar selection
- Banner image handling when community has no banner (bannerImageName is optional)
- Search dropdown styling and result item layout
- Exact spacing, padding, and margins throughout
- Pulsating glow implementation technique (e.g., PhaseAnimator, withAnimation repeating, or Canvas)

</decisions>

<specifics>
## Specific Ideas

- BD's community gets hero treatment — "Popular" badge, pulsating violet glow, category "Education & Swing Trading", starting at $29.99/mo
- Preview page should feel like a sell page — value prop leads, social proof grouped, tiers tucked behind a CTA
- Parallax banner effect on preview page for premium feel
- Stagger-fade animations for card entry — premium, polished feel
- "View Tiers" as the CTA text (not "View Plans" or "See Pricing")
- Subscribe button on expanded tier must be fully styled and tappable even though it does nothing yet
- Back button should use Blossom brand styling, not default system back arrow

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- AvatarView: size presets + verified badge + ambassador bolt — use for creator photos on cards and preview page
- BlossomCard: `.blossomCard()` ViewModifier — use for community cards in discovery list
- BlossomButton: Primary/Secondary/Ghost styles — use for "View Tiers", "Subscribe", back button
- VerifiedBadge: teal capsule with checkmark — use alongside creator names
- TagView: pill-shaped labels with .stock/.tier/.category styles — use for category tags on cards
- SectionHeader: title + optional trailing action — use for "Popular" section, list section headers
- EmptyStateView: icon + title + subtitle — use if search yields no results
- BlossomTheme: all semantic color tokens ready (background, cardSurface, cardBorder, primaryText, secondaryText, violet, teal, orange)
- BlossomFont: full type scale (largeTitle through caption)

### Established Patterns
- @MainActor @Observable for view model classes
- Feature-based folder structure: Features/Hubs/ for discovery views
- Per-tab NavigationStack isolation — new views push onto Hubs tab NavigationStack only
- CommunityStore injected via .environment() — access with @Environment(CommunityStore.self)
- HubsRoute enum already defines .communityDetail(id:) and .communityPreview(id:) routes

### Integration Points
- HubsView.swift: replace current placeholder with discovery screen (splash → browse)
- HubsNavigation.swift: wire .communityPreview(id:) route to new CommunityPreviewView
- CommunityStore: read communities array, access community.creator, community.tiers, community.memberCount
- Assets.xcassets: ambassador profile photos and logo variants already loaded
- ContentView.swift: NavigationStack for Hubs tab already set up with .navigationDestination for HubsRoute

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 03-discovery-and-community-preview*
*Context gathered: 2026-03-11*

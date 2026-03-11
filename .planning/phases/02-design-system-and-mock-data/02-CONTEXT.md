# Phase 2: Design System and Mock Data - Context

**Gathered:** 2026-03-11
**Status:** Ready for planning

<domain>
## Phase Boundary

Every visual building block and data layer needed by feature screens — color tokens, typography, dark mode support, shared UI components, a mock data service, and ambassador/logo assets — so no feature phase introduces inline hex values, raw mock arrays, or inconsistent styling.

</domain>

<decisions>
## Implementation Decisions

### Color tokens & dark mode
- Brand accent colors (Teal #35C7B2, Violet #7361F7, Orange #FF7833) stay IDENTICAL in both light and dark mode — only backgrounds, cards, and text colors adapt
- All colors defined as Asset Catalog named color sets with light/dark variants — BlossomTheme.swift references them via Color("BlossomTeal") etc.
- Dark mode cards use elevated surface (#2A2E38) with subtle 1px border (#3A3E48), matching the light mode card pattern (white + #E2E4E9 border) but inverted
- Tab bar and nav bar keep the current systemBackground approach — auto-adapts, just swap any hardcoded colors to new semantic tokens
- Dark Navy (#1E222A) used as the dark mode background color

### Typography & Inter font
- Bundle Inter .otf font files directly in the project (Inter-Regular, Inter-Medium, Inter-SemiBold) — register in Info.plist via UIAppFonts
- Three weights only: Regular (body text), Medium (labels/buttons), Semi-Bold (headlines)
- Create a BlossomFont caseless enum with static properties (.largeTitle, .headline, .subhead, .body, .callout, .caption) returning Font.custom() at correct sizes
- Retrofit ALL existing Phase 1 views to use BlossomFont — no SF Pro / Inter mixing

### Shared UI components — comprehensive core primitives
- BlossomCard ViewModifier: background, border, 12px corner radius, adapts for light/dark
- Button styles: match real Blossom app exactly (study brand-guidelines screenshots for exact styles)
- VerifiedBadge: match real Blossom app exactly (study profile-sample.png for exact badge style)
- SectionHeader: title + optional trailing action
- EmptyStateView: reusable with icon (SF Symbol), title, subtitle, optional CTA button
- LockedContentOverlay: blurred content + lock icon + upgrade prompt with tier name + action button
- TagView: pill-shaped labels with configurable styles (.stock for tickers, .tier for tier badges, .category for content categories)
- Enhanced AvatarView: add size presets, keep existing ring + badge pattern
- Loading states: use simple ProgressView spinner (no shimmer/skeleton)
- Feature-specific cards (CommunityCard, TierCard, PostCard, ThreadRow) deferred to their respective feature phases

### Mock data layer
- Single @MainActor @Observable CommunityStore class holding all mock data — injected via @Environment at app level
- 6 communities — one per ambassador (BD, Brandon, Max, Nick, Moe, Canadian in a T-shirt)
- Each community has creator-defined tiers (1-4 tiers), posts, forum threads, FAQ entries
- Realistic investing content: real stock tickers ($AAPL, $TSLA, $NVDA), trade alerts, portfolio updates, market commentary
- All 6 ambassador profile photos added to Assets.xcassets from profiles-demos/
- All 3 Blossom logo variants (light, dark, icon-square) added to Assets.xcassets from brand-guidlines/logos/
- Nick's profile photo already exists in asset catalog — add remaining 5

### Claude's Discretion
- Exact dark mode color hex values for secondary surfaces beyond the specified card background
- BlossomFont point sizes for each type scale level
- Specific community names, descriptions, and tier structures for the 6 ambassador communities
- Mock data volume (number of posts, threads, FAQ entries per community)
- TagView exact styling (padding, corner radius, font size)
- SectionHeader layout details

</decisions>

<specifics>
## Specific Ideas

- Button styles and verified badge should match the real Blossom app exactly — study brand-guidelines/app-screenshots/ for reference
- Ambassador profile photos are in profiles-demos/: BD-profile-pic.png, brandon-profile-pic.png, max-profile-pic.png, nick-profile-pic.png, Moe-profile-pic.png, "Canadia in a T-shirt-proflie-pic.png"
- Logo variants are in brand-guidlines/logos/: Blossom-logo-lightmode.png, Blossom-logo-darkmode.png, Blossom-logo-icon-square.png
- Card border in light mode is #E2E4E9 with 12px radius (from PROJECT.md brand spec)
- The Blossom app uses a friendly, casual tone — lowercase display headlines, encouraging language

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- BlossomTheme.swift: caseless enum with static Color properties — will be refactored to reference Asset Catalog color sets
- AvatarView.swift: ring + bolt badge pattern — enhance with size presets and verified badge option
- PlaceholderTabView.swift: uses system fonts — retrofit to BlossomFont
- Color(hex:) extension: may become unnecessary once colors move to Asset Catalog

### Established Patterns
- @MainActor @Observable for all view model classes (Phase 1 convention)
- Feature-based folder structure: Features/[Feature]/, Core/Theme/, Core/Components/
- Per-tab NavigationStack isolation in ContentView — new components must not break this
- BlossomTheme caseless enum pattern — extend for new semantic colors

### Integration Points
- ContentView.swift: inject CommunityStore via .environment() at app level
- BlossomHubsApp.swift: create @State var store = CommunityStore()
- Assets.xcassets: add color sets, profile photos, logos
- Info.plist: register Inter font files via UIAppFonts array
- project.pbxproj: new files must be added via xcodeproj Ruby gem (no Xcode CLI)

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 02-design-system-and-mock-data*
*Context gathered: 2026-03-11*

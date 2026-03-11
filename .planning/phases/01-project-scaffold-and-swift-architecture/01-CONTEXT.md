# Phase 1: Project Scaffold and Swift Architecture - Context

**Gathered:** 2026-03-10
**Status:** Ready for planning

<domain>
## Phase Boundary

Create the Xcode project with a 6-tab scrollable tab bar, independent NavigationStack per tab, Swift 6.2 concurrency conventions (@MainActor on all @Observable classes), and ComponentsKit integrated via SPM. The other 5 tabs show branded placeholders. The Hubs tab has the full top navigation bar matching the real Blossom app (profile avatar, search, bell, chat icons). This is the architectural shell that every subsequent phase builds on.

</domain>

<decisions>
## Implementation Decisions

### Tab Bar Appearance
- Traditional solid white tab bar — suppress iOS 26 Liquid Glass with `.toolbarBackground`
- White background in light mode, Dark Navy #1E222A in dark mode
- Active tab: Teal #35C7B2 (icon + label text) — matches real Blossom app exactly
- Inactive tabs: Light gray icons + light gray labels
- Subtle top separator line on the tab bar — matches screenshot
- **Scrollable tab bar** — do not cram all 6 icons into fixed width. Implement as a horizontally scrolling tab bar so more tabs can be added in the future
- Violet floating action button (FAB) — only show on screens where the user can take an action (e.g., FAQ submission, forum post creation). Not on every screen.

### Tab Icons, Labels, and Order
- Tab order (left to right): **Home, Hubs, Markets, Learn, Portfolio, Insights**
- Hubs is 2nd position (after Home) — prominent placement
- Icons (SF Symbols or custom to match Blossom):
  - Home: house.fill (teal when active)
  - Hubs: person.3.fill
  - Markets: globe (crosshair style matching screenshot)
  - Learn: book.fill (stacked books style)
  - Portfolio: arrow.triangle.2.circlepath (circular arrows)
  - Insights: bolt.fill (lightning bolt)
- Label: "Hubs" (not "Communities")

### Top Navigation Bar (Hubs Tab)
- Match the real Blossom app exactly:
  - Left: Nick's profile avatar (circular, teal ring border, small Blossom verified badge overlay)
  - Center: Search bar (rounded rectangle, gray background, magnifying glass + "Search" placeholder) — **functional**: tapping opens search field that filters community names
  - Right: Teal bell icon (with red notification badge) + purple dollar-sign chat bubble icon
- This top nav bar appears on the Hubs tab and is consistent with the real app

### Placeholder Tabs (Non-Hubs)
- Each of the 5 non-Hubs tabs shows a branded placeholder screen
- Content: Tab icon (large, centered), tab name as heading, "Coming soon" subtitle
- Styled with Blossom brand colors and Inter font
- Purpose: Look polished in demo, not distract from Hubs

### Demo User
- Nick is the logged-in demo user (Nick's profile photo from profiles-demos/nick-profile-pic.png)
- His avatar appears in the top-left with the teal ring + Blossom badge treatment

### Dark Mode
- Support both light and dark mode from day one (Phase 2 sets up adaptive color assets)
- App defaults to light mode on launch for consistent demo presentation
- User/system can toggle to dark mode — all screens must adapt

### Project Naming
- Xcode project name: "BlossomHubs"
- App display name: "Blossom Hubs"
- Bundle identifier: com.blossom.hubs-prototype
- App icon: Blossom-logo-icon-square.png from brand assets

### Claude's Discretion
- Exact Xcode project structure and group organization (feature-based recommended by research)
- NavigationStack path enum design per tab
- ComponentsKit import and initial configuration
- Swift 6.2 strict concurrency setup details
- Exact SF Symbol names if the ones listed don't match the Blossom screenshots closely enough

</decisions>

<specifics>
## Specific Ideas

- "Mimic the actual Blossom tab bar" — real screenshots saved at `brand-guidlines/app-screenshots/` showing both top nav and bottom tab bar. These are the definitive visual reference.
- Scrollable tab bar is inspired by wanting to add more tabs over time without cramming — think of it as future-proof navigation
- The search bar should be functional (basic community name filtering) even though search isn't a formal v1 requirement — it's a quick win that makes the demo feel real
- Nick's avatar with the teal ring and Blossom badge is a key brand detail — this verified-user visual treatment should be reusable across the app (creator badges, forum posts, etc.)

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- No existing code — greenfield project
- Profile photos available in `profiles-demos/` (BD, Brandon, Max, Nick, Moe, Canadian in a T-shirt)
- Blossom logos in `brand-guidlines/logos/` (light mode, dark mode, icon square)
- Real app screenshots in `brand-guidlines/app-screenshots/` for visual reference

### Established Patterns
- None yet — Phase 1 establishes all patterns
- Research recommends: feature-based folder structure, @Observable with @MainActor, enum-based NavigationStack routing per tab

### Integration Points
- ComponentsKit SPM dependency: `https://github.com/componentskit/ComponentsKit.git`
- Inter font files need to be added to project and registered in Info.plist (Phase 2)
- Asset catalog needs color sets for brand palette (Phase 2)

</code_context>

<deferred>
## Deferred Ideas

- None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-project-scaffold-and-swift-architecture*
*Context gathered: 2026-03-10*

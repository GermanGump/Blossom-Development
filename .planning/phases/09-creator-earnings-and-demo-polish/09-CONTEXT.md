# Phase 9: Creator Earnings and Demo Polish - Context

**Gathered:** 2026-03-16
**Status:** Ready for planning

<domain>
## Phase Boundary

The creator earnings section is added inline on the Creator Dashboard (not a separate page), featuring a SwiftUI Charts bar chart with interactive tap, revenue breakdown (gross/fee/net), and per-tier split with colored percentage bars. The complete prototype then gets a polish pass: full dark mode audit, Inter font spot-check, animation polish, and a step-by-step demo flow verification checklist.

</domain>

<decisions>
## Implementation Decisions

### Earnings layout
- Compact card section inline on the Creator Dashboard — NOT a separate page
- Replaces the current grayed-out "Earnings" placeholder
- Keep the existing "Est. Monthly" stat card at top alongside the new earnings section
- Show gross earnings, 10% Blossom fee deduction, and net payout — all three visible
- Include per-tier revenue breakdown with colored percentage bars
- Time period label shown (e.g., "March 2026" or "Last 6 Months")
- Switchable time period picker: 1M / 3M / 6M
- Claude decides positioning within dashboard layout (below section links or between stats and links)

### Chart visualization
- Bar chart (vertical bars per month) using SwiftUI Charts
- Violet gradient bars (BlossomTheme.violet with opacity gradient 0.6 to 1.0)
- Chart shows net revenue (after 10% fee), not gross
- Interactive: tap a bar to highlight and show exact dollar amount for that month
- Uses chartOverlay for tap interaction

### Demo flow polish
- Full screen-by-screen dark mode audit — every screen in the demo flow checked in dark mode
- Inter font spot-check on 5-6 key screens (discovery, preview, hub, feed, dashboard, earnings)
- Animation polish: verify existing animations (confetti, card entrance, pulsating glow) + add subtle polish touches (smoother sheet transitions, button press feedback, scroll-to-top)
- Checklist approach for end-to-end demo flow test: step-by-step script from discovery through earnings

### Earnings mock data
- 6 months of data (Oct 2025 – Mar 2026) matching the 1M/3M/6M picker
- Steady upward growth pattern (e.g., $2,800 → $3,400 → $4,100 → $4,600 → $5,200 → $5,800)
- Growing subscriber count month-over-month starting lower (~280) and reaching current 412
- Per-tier breakdown derived from actual Wealthmatica tier pricing ($0/$19/$49) with realistic distribution — most subscribers on free/low tier, fewer on premium
- Revenue growth driven by subscriber growth for coherent story

### Claude's Discretion
- Exact positioning of earnings section within dashboard layout
- Specific animation polish touches to add
- Exact mock data numbers (as long as they follow the described pattern)
- Demo checklist step granularity

</decisions>

<specifics>
## Specific Ideas

- Per-tier breakdown bars should use each tier's custom colorHex (established in Phase 8 — Observer=emerald, Investor=blue, Pro=violet)
- The 1M/3M/6M picker should feel like a segmented control, consistent with the section pager established in Phase 5
- Chart should update smoothly when switching time periods (animated transition)

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `CreatorDashboardViewModel`: Already has `estimatedRevenue` (NumberFormatter) and `subscriberCount` — extend with earnings data
- `CreatorDashboardView`: Has `statCard()` helper and `sectionLink()` helper — earnings section extends this layout
- `BlossomTheme.violet`: Primary chart color, already used for dashboard accents
- `Tier.colorHex` + `Tier.color`: Custom tier colors for breakdown bars (Phase 8)
- `blossomCard()` modifier: Standard card styling for earnings container
- `NumberFormatter(.currency)`: Already set up in CreatorDashboardViewModel

### Established Patterns
- `@State private var viewModel: VM?` with lazy `.onAppear` init (Phases 3-8)
- `CommunityStore.updateCommunity(id:update:)` inout closure for mutations
- Segmented Picker used in Phase 5 section pager — reuse for 1M/3M/6M

### Integration Points
- Replace grayed-out "Earnings" placeholder in `CreatorDashboardView` (line 79-101)
- `HubsRoute` may need `.creatorEarnings` if separate page (but decision is inline, so no new route needed)
- Dark mode audit touches all views across Features/Hubs/ and Core/Components/

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 09-creator-earnings-and-demo-polish*
*Context gathered: 2026-03-16*

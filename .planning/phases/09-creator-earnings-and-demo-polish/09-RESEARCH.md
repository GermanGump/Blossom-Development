# Phase 9: Creator Earnings and Demo Polish - Research

**Researched:** 2026-03-16
**Domain:** SwiftUI Charts, dark mode audit, Inter font verification, animation polish
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Earnings layout:**
- Compact card section inline on the Creator Dashboard — NOT a separate page
- Replaces the current grayed-out "Earnings" placeholder (CreatorDashboardView.swift lines 79-101)
- Keep the existing "Est. Monthly" stat card at top alongside the new earnings section
- Show gross earnings, 10% Blossom fee deduction, and net payout — all three visible
- Include per-tier revenue breakdown with colored percentage bars
- Time period label shown (e.g., "March 2026" or "Last 6 Months")
- Switchable time period picker: 1M / 3M / 6M

**Chart visualization:**
- Bar chart (vertical bars per month) using SwiftUI Charts
- Violet gradient bars (BlossomTheme.violet with opacity gradient 0.6 to 1.0)
- Chart shows net revenue (after 10% fee), not gross
- Interactive: tap a bar to highlight and show exact dollar amount for that month
- Uses chartOverlay for tap interaction

**Demo flow polish:**
- Full screen-by-screen dark mode audit — every screen in the demo flow checked in dark mode
- Inter font spot-check on 5-6 key screens (discovery, preview, hub, feed, dashboard, earnings)
- Animation polish: verify existing animations (confetti, card entrance, pulsating glow) + add subtle polish touches (smoother sheet transitions, button press feedback, scroll-to-top)
- Checklist approach for end-to-end demo flow test: step-by-step script from discovery through earnings

**Earnings mock data:**
- 6 months of data (Oct 2025 – Mar 2026) matching the 1M/3M/6M picker
- Steady upward growth pattern (e.g., $2,800 → $3,400 → $4,100 → $4,600 → $5,200 → $5,800)
- Growing subscriber count month-over-month starting lower (~280) and reaching current 412
- Per-tier breakdown derived from actual Wealthmatica tier pricing ($0/$19/$49) with realistic distribution
- Revenue growth driven by subscriber growth for coherent story

### Claude's Discretion
- Exact positioning of earnings section within dashboard layout
- Specific animation polish touches to add
- Exact mock data numbers (as long as they follow the described pattern)
- Demo checklist step granularity

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| CRTR-06 | Earnings view with SwiftUI Charts: gross earnings, 10% Blossom platform fee deduction, net payout, member count, and revenue trend | SwiftUI Charts bar chart API, chartOverlay tap interaction, EarningsViewModel pattern, per-tier breakdown using Tier.colorHex |
</phase_requirements>

---

## Summary

Phase 9 has two distinct workstreams: (1) implement the creator earnings card inline on the existing CreatorDashboardView, and (2) polish the entire prototype for demo-readiness. The earnings card replaces a grayed-out placeholder at lines 79-101 of CreatorDashboardView.swift. It adds a SwiftUI Charts bar chart, a time period picker, a gross/fee/net revenue breakdown, and per-tier colored percentage bars — all driven by a new earnings model struct and an extension on CreatorDashboardViewModel.

The polish pass is a systematic audit rather than new feature development. Dark mode risk is concentrated in files that use hardcoded `.white` colors on views that appear over colored backgrounds — most of these are intentional (white text on violet gradient, confetti overlay) and correct, but a few need verification. The MockPaymentSheetView uses `.white` extensively on a dark-gradient background, which is correct by design. Font risk is low: the assert in BlossomHubsApp validates Inter at app launch and BlossomFont tokens are used consistently across all views inspected.

**Primary recommendation:** Build EarningsData model + extend CreatorDashboardViewModel in one task, then implement the earnings card UI with chart in a second task, then do the dark mode/font/animation polish pass in a third task.

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| SwiftUI Charts | iOS 17+ (bundled) | Bar chart for revenue trend | Apple-native, no extra dependency, integrates with dark mode automatically |
| SwiftUI | iOS 26 / Swift 6.2 | All UI | Project constraint |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| Foundation (Decimal, NumberFormatter) | bundled | Currency math without floating point errors | All earnings calculations |
| SwiftUI Picker (segmented style) | bundled | 1M/3M/6M time period switcher | Matches Phase 5 segmented pager pattern |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| SwiftUI Charts | Custom Canvas drawing | Charts provides native axis labels, annotations, dark mode — Canvas requires full manual implementation |
| Decimal arithmetic | Double | Double accumulates floating point error in currency math |

**Installation:** No new packages required — SwiftUI Charts is bundled in iOS 17+ and the project targets iOS 26.

---

## Architecture Patterns

### Recommended Project Structure
No new files or folders required. Changes are:
```
BlossomHubs/Features/Hubs/Creator/
├── CreatorDashboardViewModel.swift   # extend with EarningsData + earningsByPeriod
├── CreatorDashboardView.swift        # replace placeholder with earningsSection()
```

A new `EarningsData` struct (6-element array of monthly snapshots) lives in `CreatorDashboardViewModel.swift` alongside the ViewModel.

### Pattern 1: SwiftUI Charts Bar Chart with chartOverlay Tap

**What:** Vertical bar chart with tap-to-highlight interaction via `chartOverlay`.
**When to use:** Revenue trend visualization with interactive month selection.

```swift
// Source: Apple developer documentation — Charts framework
import Charts

Chart(viewModel.chartData(for: selectedPeriod)) { point in
    BarMark(
        x: .value("Month", point.monthLabel),
        y: .value("Net Revenue", point.netRevenue)
    )
    .foregroundStyle(
        LinearGradient(
            colors: [BlossomTheme.violet.opacity(0.6), BlossomTheme.violet],
            startPoint: .bottom,
            endPoint: .top
        )
    )
    .opacity(selectedMonth == nil || selectedMonth == point.monthLabel ? 1.0 : 0.4)
    .cornerRadius(4)
}
.chartOverlay { proxy in
    GeometryReader { geo in
        Rectangle()
            .fill(.clear)
            .contentShape(Rectangle())
            .onTapGesture { location in
                let relativeX = location.x - geo[proxy.plotAreaFrame].origin.x
                if let month: String = proxy.value(atX: relativeX) {
                    selectedMonth = (selectedMonth == month) ? nil : month
                }
            }
    }
}
.frame(height: 160)
.chartYAxis {
    AxisMarks(format: .currency(code: "USD").precision(.fractionLength(0)))
}
```

### Pattern 2: Time Period Picker (Segmented Style)

**What:** Reuse the Phase 5 Picker(segmented) pattern for 1M / 3M / 6M.
**When to use:** Matching established dashboard and community pager patterns.

```swift
// Matches Phase 5 segmented control pattern
enum EarningsPeriod: String, CaseIterable {
    case oneMonth = "1M"
    case threeMonths = "3M"
    case sixMonths = "6M"
}

Picker("Period", selection: $selectedPeriod) {
    ForEach(EarningsPeriod.allCases, id: \.self) { period in
        Text(period.rawValue).tag(period)
    }
}
.pickerStyle(.segmented)
.padding(.horizontal, 16)
```

### Pattern 3: Gross / Fee / Net Breakdown Row

**What:** Three rows showing gross, fee deduction, and net payout with currency formatting.
**When to use:** Revenue math transparency (CRTR-06 requirement).

```swift
// NumberFormatter already set up in CreatorDashboardViewModel
private func revenueRow(label: String, amount: Decimal, isDeduction: Bool = false) -> some View {
    HStack {
        Text(label)
            .font(BlossomFont.caption)
            .foregroundStyle(BlossomTheme.secondaryText)
        Spacer()
        Text(formatted(amount))
            .font(BlossomFont.subhead)
            .fontWeight(.semibold)
            .foregroundStyle(isDeduction ? BlossomTheme.orange : BlossomTheme.primaryText)
    }
}
```

### Pattern 4: Per-Tier Percentage Bar

**What:** Colored progress bar per tier using `Tier.colorHex` via `Tier.color`.
**When to use:** Showing which tier drives most revenue.

```swift
// Tier.color is already a computed property using Color.fromHex(colorHex)
ForEach(Array(viewModel.tierBreakdown(for: selectedPeriod).enumerated()), id: \.offset) { _, item in
    VStack(spacing: 4) {
        HStack {
            Circle()
                .fill(item.tier.color)
                .frame(width: 8, height: 8)
            Text(item.tier.name)
                .font(BlossomFont.caption)
                .foregroundStyle(BlossomTheme.primaryText)
            Spacer()
            Text(String(format: "%.0f%%", item.percentage * 100))
                .font(BlossomFont.caption)
                .foregroundStyle(BlossomTheme.secondaryText)
        }
        GeometryReader { geo in
            RoundedRectangle(cornerRadius: 2)
                .fill(item.tier.color.opacity(0.2))
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(item.tier.color)
                        .frame(width: geo.size.width * item.percentage)
                }
        }
        .frame(height: 6)
    }
}
```

### Pattern 5: EarningsData Model

**What:** Lightweight struct for monthly earnings snapshots, scoped to the ViewModel file.
**When to use:** Backing the chart and all revenue breakdown math.

```swift
struct MonthlyEarningsPoint: Identifiable {
    let id = UUID()
    let monthLabel: String           // "Oct", "Nov", etc.
    let monthDate: Date              // for sorting
    let grossRevenue: Decimal
    var platformFee: Decimal { grossRevenue * 0.10 }
    var netRevenue: Decimal { grossRevenue - platformFee }
    let subscriberCount: Int
    // tier breakdown: [tierIndex: subscriberCount]
    let tierSubscriberCounts: [Int: Int]
}
```

### Anti-Patterns to Avoid

- **Separate navigation route for earnings:** Decision is locked — earnings is inline on the dashboard, not a new page. Do NOT add `.creatorEarnings` to `HubsRoute`.
- **Double/Float for currency math:** Use `Decimal` throughout; `Double(5800) * 0.10` can produce `579.9999...`.
- **Hardcoded gross in chart:** Chart displays net revenue per the locked decision; gross appears only in the breakdown rows.
- **Global chart state in View body:** Keep `selectedMonth` and `selectedPeriod` as `@State` in the View; they do not belong in the ViewModel.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Bar chart rendering | Custom Canvas bars | `Chart` + `BarMark` | Axis labels, annotations, dark mode, and accessibility come free |
| Tap-to-highlight | Manual geometry math | `chartOverlay` + `proxy.value(atX:)` | Charts proxy handles coordinate-to-data-value mapping |
| Currency formatting | Manual string concat | `NumberFormatter(.currency)` already in ViewModel | Already set up, handles locale/rounding correctly |
| Tier colors | New color definitions | `Tier.color` (existing computed property) | Phase 8 already established Observer=emerald, Investor=blue, Pro=violet |
| Segmented picker | Custom tab buttons | `Picker(.segmented)` | Matches Phase 5 pattern; system provides dark mode, selection highlight |

**Key insight:** SwiftUI Charts handles dark mode adaptation automatically — the axis labels, grid lines, and bar marks all adapt. No custom dark mode logic is needed for the chart itself.

---

## Common Pitfalls

### Pitfall 1: `chartOverlay` coordinate space mismatch

**What goes wrong:** `proxy.value(atX:)` returns nil or wrong values because the raw tap location is in the GeometryReader frame, not the chart plot area frame.
**Why it happens:** The chart's plot area does not span the full view frame — axes and labels consume space on the left and bottom.
**How to avoid:** Subtract the plot area origin: `let relativeX = location.x - geo[proxy.plotAreaFrame].origin.x`. Only call `proxy.value(atX:)` with the adjusted coordinate.
**Warning signs:** `proxy.value(atX:)` always returns nil even on valid bars.

### Pitfall 2: Decimal math for the 10% fee

**What goes wrong:** Using `Double` for the platform fee calculation produces floating-point rounding errors visible in currency display (e.g., $519.99999 instead of $520.00).
**Why it happens:** Double IEEE 754 binary representation cannot represent 0.1 exactly.
**How to avoid:** All arithmetic uses `Decimal`. The existing `NumberFormatter` in `CreatorDashboardViewModel.estimatedRevenue` already uses `NSDecimalNumber`.
**Warning signs:** Currency display shows extra cents that don't add up.

### Pitfall 3: `.foregroundColor()` vs `.foregroundStyle()`

**What goes wrong:** Using the deprecated `.foregroundColor()` modifier instead of `.foregroundStyle()`. The swiftui-pro skill flags this as a rule violation.
**Why it happens:** Muscle memory / older code examples.
**How to avoid:** All new code in Phase 9 uses `.foregroundStyle()`. The existing `.foregroundColor(.white)` instances in `HubsTopNavBar.swift` (line 35) and `CancelRetentionSheet.swift` (line 65) should be updated to `.foregroundStyle(.white)` during the polish pass.
**Warning signs:** Xcode may show deprecation warnings depending on SDK version.

### Pitfall 4: White text that looks broken in dark mode (but isn't)

**What goes wrong:** Auditor flags `.white` text as a dark mode bug when it is intentional (white text on a colored/dark overlay background).
**Why it happens:** Confusion between adaptive semantic colors and intentionally non-adaptive whites.
**How to avoid:** Distinguish two cases:
  - **Correct `.white`:** `MockPaymentSheetView` (dark gradient background — white is intentional), `ConfettiCelebrationView` (black overlay — white is intentional), `HubsTopNavBar` "9+" badge (red background — white is correct), FAB "+" icon (violet circle background — white is correct), `AvatarView` badge ring (white stroke for visual separation on any background).
  - **Verify carefully:** `CancelRetentionSheet.swift` line 65 — check if the button appears on a surface that could be light-mode white card, making white text invisible.
**Warning signs:** Text disappears in light mode (white-on-white is the actual bug to catch, not white-on-dark).

### Pitfall 5: `cornerRadius()` deprecated modifier

**What goes wrong:** `SearchDropdownView.swift` line 70 uses `.cornerRadius(10)` — this is deprecated per swiftui-pro skill `api.md`.
**Why it happens:** Legacy pattern from before `clipShape(.rect(cornerRadius:))` was available.
**How to avoid:** Replace with `.clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))` or `.clipShape(.rect(cornerRadius: 12))` during polish pass.
**Warning signs:** Xcode deprecation warning.

### Pitfall 6: Inter font silent fallback

**What goes wrong:** `Font.custom("Inter-SemiBold", size: 17)` silently falls back to SF Pro if the PostScript name doesn't match the registered font.
**Why it happens:** Font names are case/space sensitive. The project confirmed PostScript names as `Inter-Regular`, `Inter-Medium`, `Inter-SemiBold` (Phase 02-01 decision).
**How to avoid:** The existing `BlossomHubsApp` asserts (`UIFont(name: "Inter-Regular", size: 17) != nil`) catch this at runtime. The spot-check in the polish pass is a visual confirmation that the asserts passed and the font renders with correct weight differentiation (compare `BlossomFont.headline` vs `BlossomFont.body` — semibold should visibly differ from regular).
**Warning signs:** All text weights look identical (hairline/thin appearance means SF Pro fallback).

---

## Code Examples

Verified patterns from codebase inspection:

### Existing NumberFormatter pattern (extend, don't duplicate)
```swift
// Source: CreatorDashboardViewModel.swift — existing pattern to reuse
let formatter = NumberFormatter()
formatter.numberStyle = .currency
formatter.currencyCode = "USD"
formatter.maximumFractionDigits = 2
return formatter.string(from: total as NSDecimalNumber) ?? "$0.00"
```

### Existing Tier.color usage pattern
```swift
// Source: Community.swift — Tier.color computed property
var color: Color {
    Color.fromHex(colorHex)
}
// Wealthmatica tiers: Observer="10B981"(emerald), Investor="3B82F6"(blue), Pro="7C3AED"(violet)
```

### Existing Segmented Picker pattern (Phase 5)
```swift
// Pattern established in Phase 5 — reuse verbatim style
Picker("Section", selection: $selectedSection) {
    ForEach(sections, id: \.self) { section in
        Text(section.title).tag(section)
    }
}
.pickerStyle(.segmented)
```

### CommunityStore.updateCommunity inout pattern (Phase 8)
```swift
// Source: Phase 08-01 decision — all creator mutations use this
communityStore.updateCommunity(id: communityID) { community in
    community.memberCount = newCount
}
```

### Earnings mock data structure (6 months)
```swift
// Oct 2025 – Mar 2026, net revenue growth $2,520 → $5,220
// Gross: $2,800, $3,400, $4,100, $4,600, $5,200, $5,800
// Fee (10%): $280, $340, $410, $460, $520, $580
// Net: $2,520, $3,060, $3,690, $4,140, $4,680, $5,220
// Subscribers: ~280, ~305, ~330, ~358, ~385, 412
// Tier distribution (realistic): ~65% Observer(free), ~25% Investor($19), ~10% Pro($49)
// Revenue math: free tier = $0, Investor revenue = count * $19, Pro revenue = count * $49
```

---

## Dark Mode Audit Findings

### Files with `.white` usage — categorized by risk

| File | Usage | Risk | Action |
|------|-------|------|--------|
| `MockPaymentSheetView.swift` | White text on dark gradient background | NONE — intentional by design | No change needed |
| `ConfettiCelebrationView.swift` | White text + `blossom-logo-white` on `Color.black.opacity(0.6)` overlay | NONE — intentional | No change needed |
| `HubsTopNavBar.swift` line 35 | White "9+" on `Color.red` capsule | NONE — correct | Update `.foregroundColor` → `.foregroundStyle` (deprecated API) |
| `CommunityHubView.swift` line 121 | White "+" FAB icon on `BlossomTheme.violet` circle | NONE — correct | Update `.foregroundColor` → `.foregroundStyle` |
| `AvatarView.swift` line 51 | White ring stroke on avatar circle | NONE — visual separator that works on any background | No change needed |
| `AvatarView.swift` line 60 | White background behind badge | LOW — verify badge renders on dark card surface | Check simulator |
| `CancelRetentionSheet.swift` line 65 | White text on button | CHECK — verify the button has a colored background | Read file in planning phase |
| `BlossomButton.swift` line 10 | White text on primary button (teal background) | NONE — correct | Update `.foregroundColor` → `.foregroundStyle` |
| `TagView.swift` | White text on subscribed tag | NONE — subscribed tag has colored background | No change needed |
| `CommunityPreviewView.swift` line 80, 85 | White ring + stroke on avatar over banner | NONE — intentional over image | No change needed |
| `CommunityLandingSection.swift` line 20, 25 | Same as above | NONE | No change needed |
| `ComposePostView.swift` | White foreground on colored chip | CHECK during polish | Verify chip background is always colored |
| `TierEditSheet.swift` | White foreground on colored element | CHECK during polish | Verify in dark mode |
| `CommunityEditView.swift` | White foreground on image overlay controls | LOW — overlay on photo, check dark mode | Verify |
| `YouTubeLinkCard.swift` line 71 | White play icon on video thumbnail overlay | NONE — correct | No change needed |

### Files with NO dark mode risk (fully semantic colors)
All other files use only `BlossomTheme.*` tokens + `Color(UIColor.systemGray*)` which adapt automatically.

### HubsSplashView — already correct
Uses `@Environment(\.colorScheme)` to switch between `blossom-logo-dark` and `blossom-logo-light` asset catalog images. Dark mode is correctly handled.

---

## Earnings Section Placement

**Recommended position:** Between the stat cards row and the section links block.

Rationale: The "Est. Monthly" stat card gives a single number at a glance. The earnings section directly below expands on that number with the chart and breakdown — natural information hierarchy. The section links (Edit, Tiers, Permissions, Publish) are action items and should remain at the bottom.

Layout order in CreatorDashboardView scrollable VStack:
1. Creator context header (unchanged)
2. Stat cards: Subscribers + Est. Monthly (unchanged)
3. **NEW: Earnings card** — time picker + chart + gross/fee/net + tier bars
4. Section links: Edit, Tiers, Permissions, Publish (unchanged, earnings placeholder removed)

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Custom Canvas charts | SwiftUI Charts (`Chart` + `BarMark`) | iOS 16 (Charts), stable since iOS 17 | Native axis, annotations, dark mode, accessibility |
| `.foregroundColor()` | `.foregroundStyle()` | iOS 15+ | `.foregroundColor` is deprecated in iOS 17 SDK |
| `.cornerRadius()` | `.clipShape(.rect(cornerRadius:))` | iOS 17+ | Old modifier is deprecated |

**Deprecated/outdated in this codebase (fix during polish):**
- `.foregroundColor()`: `HubsTopNavBar` line 35, `CancelRetentionSheet` line 65, `BlossomButton` line 10 — replace with `.foregroundStyle()`
- `.cornerRadius()`: `SearchDropdownView` line 70 (`cornerRadius(10)`) — the nearby `.clipShape(RoundedRectangle...)` already clips the view; the stacked `.cornerRadius` is redundant and deprecated

---

## Open Questions

1. **CancelRetentionSheet line 65 — white text target**
   - What we know: `.foregroundColor(.white)` appears in the sheet
   - What's unclear: Whether the button has a colored background in both light and dark mode
   - Recommendation: Read the file during plan task definition to confirm; treat as LOW risk until verified

2. **`Chart` import availability on iOS 26 simulator**
   - What we know: SwiftUI Charts shipped with iOS 16, is stable on iOS 17+
   - What's unclear: No breaking changes known for iOS 26 but not directly verified via live docs
   - Recommendation: HIGH confidence it works; the `import Charts` statement is all that's needed

3. **`proxy.value(atX:)` type inference for `String` x-axis values**
   - What we know: When `x: .value("Month", point.monthLabel)` uses `String`, `proxy.value(atX:)` must explicitly type as `String`
   - What's unclear: Whether String-keyed x-axis works as cleanly as Date or Double-keyed
   - Recommendation: Use `Int` month index as the x-axis data type internally, display String labels via `AxisValueLabel` — more reliable coordinate mapping

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None detected — prototype uses Xcode Simulator visual verification |
| Config file | none |
| Quick run command | Build + run in simulator: Cmd+R |
| Full suite command | N/A — manual visual verification per demo checklist |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| CRTR-06 | Earnings view renders with chart, gross/fee/net math correct, time picker works | manual-only | N/A — visual/interactive verification in iOS Simulator | ❌ Wave 0 |
| CRTR-06 | Inter font renders at correct weight across demo screens | manual-only | N/A — UIFont assert in app launch catches registration, visual check confirms weight | ❌ Wave 0 |
| CRTR-06 | Dark mode audit passes all demo flow screens | manual-only | N/A — toggle Appearance in simulator | ❌ Wave 0 |
| CRTR-06 | End-to-end demo flow runs without errors | manual-only | N/A — step-by-step checklist | ❌ Wave 0 |

**Justification for manual-only:** This is a UI prototype with no backend. There is no unit-testable business logic that isn't already validated by Swift type safety. The earnings math (10% fee) is trivial `Decimal` arithmetic verified visually. The phase success criteria are inherently visual (dark mode, font weight, chart appearance, animation smoothness).

### Sampling Rate
- **Per task commit:** Build project in simulator, verify the changed screen
- **Per wave merge:** Run full demo flow checklist (discovery → browse → preview → payment → confetti → hub → feed → forum → FAQ → dashboard → earnings)
- **Phase gate:** Full demo checklist green before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] Demo flow checklist document — create as a comment block in the PLAN or as an inline verification step
- [ ] No framework install needed — no new test infrastructure required

---

## Sources

### Primary (HIGH confidence)
- Codebase inspection — `CreatorDashboardView.swift`, `CreatorDashboardViewModel.swift`, `BlossomTheme.swift`, `BlossomFont.swift`, `Community.swift`, `CommunityStore.swift`, `ConfettiCelebrationView.swift`, `HubsSplashView.swift` — direct code reading
- `/Users/nsimpson/.claude/skills/swiftui-pro/references/api.md` — deprecated API rules (foregroundColor, cornerRadius, foregroundStyle)

### Secondary (MEDIUM confidence)
- Apple SwiftUI Charts documentation — `chartOverlay`, `BarMark`, `proxy.value(atX:)` patterns are stable API since iOS 16; coordinate adjustment pattern (subtract plot area origin) is well-documented
- Phase history in STATE.md — all established patterns (segmented picker from Phase 5, updateCommunity from Phase 8, Decimal currency math from ViewModel)

### Tertiary (LOW confidence)
- None — all findings are grounded in direct codebase inspection or established SwiftUI Charts API

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — SwiftUI Charts is bundled, no new dependencies, confirmed in codebase
- Architecture: HIGH — earnings placement and patterns derived directly from existing code structure
- Pitfalls: HIGH — dark mode risk assessed by reading every file with `.white` usage; font risk assessed via existing assert mechanism
- Mock data math: HIGH — tier prices confirmed from CommunityStore.swift ($0/$19/$49), growth pattern from locked decisions

**Research date:** 2026-03-16
**Valid until:** 2026-04-16 (stable APIs — SwiftUI Charts has not had breaking changes since iOS 16)

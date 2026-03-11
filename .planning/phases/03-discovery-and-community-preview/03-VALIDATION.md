---
phase: 3
slug: discovery-and-community-preview
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-11
---

# Phase 3 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | None — no test target in BlossomHubs.xcodeproj |
| **Config file** | None — Wave 0 adds debug assertions |
| **Quick run command** | Build in Xcode (Cmd+B) or `xcodebuild -scheme BlossomHubs -destination "platform=iOS Simulator,name=iPhone 16 Pro" build` |
| **Full suite command** | Manual visual validation checklist in Simulator |
| **Estimated runtime** | ~30 seconds (build + inspect) |

---

## Sampling Rate

- **After every task commit:** Build must succeed (zero Swift 6 concurrency errors, zero undefined symbol errors)
- **After every plan wave:** Manual Simulator run — verify splash, discovery cards, navigation, preview page, tier sheet
- **Before `/gsd:verify-work`:** All 7 requirements confirmed via Simulator walkthrough
- **Max feedback latency:** 30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 03-01-01 | 01 | 1 | DISC-01 | visual | Simulator: launch → splash appears → auto-dismisses | manual-only | ⬜ pending |
| 03-01-02 | 01 | 1 | DISC-02 | visual | Simulator: discovery screen shows hero + 5 list cards | manual-only | ⬜ pending |
| 03-01-03 | 01 | 1 | DISC-03 | visual | Simulator: verify card fields (logo, name, photo, badge, desc, members) | manual-only | ⬜ pending |
| 03-01-04 | 01 | 1 | DISC-04 | visual | Simulator: tap card → preview pushes on Hubs tab only | manual-only | ⬜ pending |
| 03-02-01 | 02 | 2 | SUBS-01 | visual | Simulator: preview shows description, value prop, creator bio | manual-only | ⬜ pending |
| 03-02-02 | 02 | 2 | SUBS-02 | visual | Simulator: tier sheet shows 1-4 tiers with names and prices | manual-only | ⬜ pending |
| 03-02-03 | 02 | 2 | SUBS-03 | visual | Simulator: tap tier → accordion expands with benefits; tap another → first collapses | manual-only | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] No formal XCTest target needed — Swift 6 strict concurrency compiler is the automated test
- [ ] Visual validation in Simulator covers all 7 requirements (all are UI/navigation behaviors)
- [ ] Build verification via `xcodebuild build` confirms compilation

*Existing infrastructure: Swift 6 strict concurrency enforcement (compiler catches actor isolation bugs)*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Splash shows once and persists | DISC-01 | @AppStorage persistence + animation needs human verification | Launch app → verify splash → force-quit → relaunch → verify no splash |
| Discovery cards display correctly | DISC-02, DISC-03 | Visual layout requires human eye | Scroll discovery screen, verify hero card + 5 list cards with all required fields |
| Card tap navigates correctly | DISC-04 | Navigation + tab isolation needs runtime check | Tap card → verify preview pushes in Hubs tab; switch tabs → verify other tabs unaffected |
| Preview page content | SUBS-01 | Visual layout and content order | Verify value prop → creator bio → description order on preview page |
| Tier sheet and expansion | SUBS-02, SUBS-03 | Interactive accordion behavior | Tap "View Tiers" → verify tier count → tap tier → verify expansion → tap another → verify collapse |
| Dark mode adapts | FOUND-06 | Visual appearance | Toggle dark mode in Simulator → verify all new screens adapt correctly |
| Parallax banner | CONTEXT | Animation behavior | Scroll preview page → verify banner scrolls slower than content |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 30s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending

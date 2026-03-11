---
phase: 2
slug: design-system-and-mock-data
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-11
---

# Phase 2 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | None — no test target in BlossomHubs.xcodeproj |
| **Config file** | None — Wave 0 adds debug assertions |
| **Quick run command** | Build in Xcode (Cmd+B) |
| **Full suite command** | Manual visual validation checklist in Simulator |
| **Estimated runtime** | ~30 seconds (build + inspect) |

---

## Sampling Rate

- **After every task commit:** Build must succeed (zero Swift 6 concurrency errors, zero undefined symbol errors)
- **After every plan wave:** Manual Simulator run — verify dark mode toggle, font rendering, asset images
- **Before `/gsd:verify-work`:** All 5 success criteria confirmed
- **Max feedback latency:** 30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 02-01-01 | 01 | 1 | FOUND-04 | build | `xcodebuild build` | ❌ W0 | ⬜ pending |
| 02-01-02 | 01 | 1 | FOUND-05 | debug assertion | assert in App.init() | ❌ W0 | ⬜ pending |
| 02-02-01 | 02 | 1 | FOUND-06 | visual | Simulator dark mode toggle | manual-only | ⬜ pending |
| 02-02-02 | 02 | 1 | FOUND-09 | debug assertion | assert in App.init() | ❌ W0 | ⬜ pending |
| 02-03-01 | 03 | 2 | FOUND-10 | visual | Simulator + Image("name") load | manual-only | ⬜ pending |
| 02-03-02 | 03 | 2 | FOUND-11 | visual | Simulator + Image("name") load | manual-only | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `BlossomHubs/App/BlossomHubsApp.swift` — add `#if DEBUG` font load assertion (UIFont.familyNames contains "Inter")
- [ ] `BlossomHubs/App/BlossomHubsApp.swift` — add `#if DEBUG` CommunityStore data count assertion (≥ 3 communities with tiers/posts)
- [ ] No formal XCTest target needed — Swift 6 strict concurrency compiler is the automated test; visual validation in Simulator

*Existing infrastructure: Swift 6 strict concurrency enforcement (compiler catches actor isolation bugs)*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Dark mode adapts correctly | FOUND-06 | Visual appearance requires human eye | Toggle Settings > Display > Dark Mode in Simulator, verify no white-on-white cards or invisible text |
| Profile photos render | FOUND-10 | Image rendering is visual | Launch app, navigate to Hubs, verify avatar shows photo not placeholder |
| Logo images render | FOUND-11 | Image rendering is visual | Verify all 3 logo variants display correctly in relevant views |
| Inter font renders | FOUND-05 | Font rendering needs visual confirmation | Compare headlines/body text against SF Pro — Inter has distinct letterforms |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 30s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending

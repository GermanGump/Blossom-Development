---
phase: 9
slug: creator-earnings-and-demo-polish
status: draft
nyquist_compliant: true
wave_0_complete: false
created: 2026-03-16
---

# Phase 9 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | xcodebuild (SwiftUI prototype — build verification only) |
| **Config file** | BlossomHubs/BlossomHubs.xcodeproj |
| **Quick run command** | `xcodebuild build -project BlossomHubs/BlossomHubs.xcodeproj -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath BlossomHubs/Build` |
| **Full suite command** | Same as quick (no test target — prototype project) |
| **Estimated runtime** | ~30 seconds |

---

## Sampling Rate

- **After every task commit:** Run build command
- **After every plan wave:** Run build + install on simulator
- **Before `/gsd:verify-work`:** Full build must succeed and app must launch
- **Max feedback latency:** 30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 09-01-01 | 01 | 1 | CRTR-06 | build | `xcodebuild build ...` | N/A | pending |
| 09-01-02 | 01 | 1 | CRTR-06 | build | `xcodebuild build ...` | N/A | pending |
| 09-02-01 | 02 | 2 | CRTR-06 | build | `xcodebuild build ...` | N/A | pending |
| 09-02-02 | 02 | 2 | CRTR-06 | manual | visual inspection | N/A | pending |

*Status: pending · green · red · flaky*

---

## Wave 0 Requirements

Existing infrastructure covers all phase requirements. No new test framework needed — this is a SwiftUI prototype with build verification and manual visual inspection.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Earnings math correctness | CRTR-06 | Visual inspection of gross/fee/net values | Verify $5,820 gross - $582 fee = $5,238 net |
| Chart tap interaction | CRTR-06 | Gesture-based interaction | Tap bar in chart, verify tooltip shows correct value |
| Dark mode audit | SC-4 | Visual rendering check | Toggle dark mode in simulator, walk all screens |
| Inter font rendering | SC-5 | Visual font check | Spot-check key screens for Inter vs SF Pro fallback |
| End-to-end demo flow | SC-3 | Full user journey | Walk discovery → subscribe → hub → feed → forum → FAQ → dashboard → earnings |

---

## Validation Sign-Off

- [x] All tasks have build verify or manual verification
- [x] Sampling continuity: build after every task
- [x] Wave 0 covers all MISSING references
- [x] No watch-mode flags
- [x] Feedback latency < 30s
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** pending

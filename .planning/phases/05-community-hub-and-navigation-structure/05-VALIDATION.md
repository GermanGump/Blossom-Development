---
phase: 5
slug: community-hub-and-navigation-structure
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-13
---

# Phase 5 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Xcode XCTest (bundled with Xcode) |
| **Config file** | BlossomHubs.xcodeproj test target (Wave 0 if not present) |
| **Quick run command** | `xcodebuild build -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16 Pro'` |
| **Full suite command** | `xcodebuild build -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16 Pro'` |
| **Estimated runtime** | ~30 seconds |

---

## Sampling Rate

- **After every task commit:** Run `xcodebuild build` — project must compile
- **After every plan wave:** Build + visual preview renders for all 6 communities
- **Before `/gsd:verify-work`:** Full build green, all communities render correctly
- **Max feedback latency:** 30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 05-01-01 | 01 | 1 | HUB-01, HUB-02 | build | `xcodebuild build` | N/A | pending |
| 05-01-02 | 01 | 1 | HUB-01, HUB-02 | build | `xcodebuild build` | N/A | pending |
| 05-02-01 | 02 | 2 | HUB-08 | build | `xcodebuild build` | N/A | pending |
| 05-02-02 | 02 | 2 | HUB-08 | build | `xcodebuild build` | N/A | pending |

*Status: pending / green / red / flaky*

---

## Wave 0 Requirements

Existing infrastructure covers all phase requirements — this phase is UI-only with build verification. No unit test target needed for mock-data SwiftUI views.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Landing page displays banner, logo, title, description | HUB-01 | Visual layout verification | Open each community, verify banner renders with gradient, logo overlaps, text correct |
| Link-tree shows correct sections per community | HUB-02 | Data-driven visual check | Verify link-tree rows match community's non-empty content arrays |
| Segmented control switches sections | HUB-08 | Interaction verification | Tap each segment, verify content changes; swipe between sections |
| Welcome card shows on first entry only | HUB-08 | State persistence check | Subscribe, verify welcome card; re-enter, verify no card |
| Sticky segmented control | HUB-08 | Scroll behavior | Scroll down, verify segmented control pins below header |
| Post-confetti navigation to hub | HUB-08 | Navigation flow check | Complete subscription, verify confetti -> hub with welcome overlay (not back to discovery) |

---

## Validation Sign-Off

- [ ] All tasks have build verification
- [ ] Sampling continuity: build after every task
- [ ] No watch-mode flags
- [ ] Feedback latency < 30s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending

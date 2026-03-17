---
phase: 10
slug: ad-placement-system
status: draft
nyquist_compliant: true
wave_0_complete: false
created: 2026-03-17
---

# Phase 10 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | xcodebuild (SwiftUI preview + build verification) |
| **Config file** | BlossomHubs/BlossomHubs.xcodeproj |
| **Quick run command** | `xcodebuild build -project BlossomHubs/BlossomHubs.xcodeproj -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath BlossomHubs/Build 2>&1 \| tail -5` |
| **Full suite command** | `xcodebuild build -project BlossomHubs/BlossomHubs.xcodeproj -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath BlossomHubs/Build` |
| **Estimated runtime** | ~30 seconds |

---

## Sampling Rate

- **After every task commit:** Run quick build command
- **After every plan wave:** Run full build
- **Before `/gsd:verify-work`:** Full build must succeed
- **Max feedback latency:** 30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 10-01-01 | 01 | 1 | AD-DATA | build | `xcodebuild build ...` | ❌ W0 | ⬜ pending |
| 10-01-02 | 01 | 1 | AD-BANNER | build | `xcodebuild build ...` | ❌ W0 | ⬜ pending |
| 10-01-03 | 01 | 1 | AD-INLINE | build | `xcodebuild build ...` | ❌ W0 | ⬜ pending |
| 10-01-04 | 01 | 1 | AD-PILL | build | `xcodebuild build ...` | ❌ W0 | ⬜ pending |
| 10-02-01 | 02 | 2 | AD-PLACE | build + visual | `xcodebuild build ...` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

*Existing infrastructure covers all phase requirements. No new test framework needed — build verification via xcodebuild is the validation mechanism for this UI-only phase.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Banner ad renders above featured hub on discovery | AD-BANNER | Visual layout verification | Open Hubs tab, verify banner appears above Featured Hub section |
| Inline card ad renders between posts in content feed | AD-INLINE | Visual layout verification | Navigate to a community content feed, scroll to verify ad card appears between posts 3-6 |
| Pill ad renders between community cards in category explore | AD-PILL | Visual layout verification | Tap a category section, verify pill ads appear at regular cadence |
| Ads open Safari on tap | AD-INTERACT | Requires Simulator interaction | Tap each ad format, verify Safari opens with correct URL |
| Blossom PRO ad has violet accent and "Upgrade" label | AD-PRO | Visual style check | Find a Blossom PRO ad, verify distinct styling |
| "Sponsored" label visible on all ad formats | AD-LABEL | Visual check | Verify each format shows Sponsored/Ad/Upgrade label |

---

## Validation Sign-Off

- [x] All tasks have build verification
- [x] Sampling continuity: build after every task
- [x] No watch-mode flags
- [x] Feedback latency < 30s
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** pending

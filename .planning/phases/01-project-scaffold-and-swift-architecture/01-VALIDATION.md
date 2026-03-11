---
phase: 1
slug: project-scaffold-and-swift-architecture
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-10
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Xcode Build + Swift Compiler (no unit test framework needed for Phase 1) |
| **Config file** | BlossomHubs.xcodeproj |
| **Quick run command** | `xcodebuild build -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16 Pro'` |
| **Full suite command** | `xcodebuild build -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16 Pro' 2>&1 \| grep -E '(error:|warning:|BUILD)'` |
| **Estimated runtime** | ~15 seconds |

---

## Sampling Rate

- **After every task commit:** Run quick build command
- **After every plan wave:** Run full suite command
- **Before `/gsd:verify-work`:** Full suite must build with zero errors/warnings
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 01-01-01 | 01 | 1 | FOUND-01 | build | `xcodebuild build -scheme BlossomHubs` | ❌ W0 | ⬜ pending |
| 01-01-02 | 01 | 1 | FOUND-08 | build | `xcodebuild build -scheme BlossomHubs` | ❌ W0 | ⬜ pending |
| 01-02-01 | 02 | 1 | FOUND-02 | manual | Verify 6 tabs visible in Simulator | ❌ W0 | ⬜ pending |
| 01-02-02 | 02 | 1 | FOUND-03 | manual | Navigate within tabs, verify no state bleed | ❌ W0 | ⬜ pending |
| 01-03-01 | 03 | 1 | FOUND-07 | build | Zero Swift 6 concurrency warnings | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] Xcode project created with correct scheme name "BlossomHubs"
- [ ] ComponentsKit SPM dependency resolves and builds

*Existing infrastructure covers remaining phase requirements.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| 6-tab bar displays correctly | FOUND-02 | Visual layout verification | Launch in Simulator, verify all 6 tab labels visible and scrollable |
| Tab navigation isolation | FOUND-03 | Navigation state is visual | Tap Hubs, push a view, switch to Home, switch back — verify Hubs retains its stack |
| Teal active / gray inactive | CONTEXT | Brand compliance visual check | Tap each tab, verify active state is Teal #35C7B2 and inactive is light gray |
| Top nav bar matches Blossom | CONTEXT | Visual design match | Compare Hubs top bar to brand-guidlines/app-screenshots/ |

*If none: "All phase behaviors have automated verification."*

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 15s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending

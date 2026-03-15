---
status: testing
phase: 07-engagement-forums-and-faq
source: [07-01-SUMMARY.md, 07-02-SUMMARY.md]
started: 2026-03-15T15:00:00Z
updated: 2026-03-15T15:00:00Z
---

## Current Test

number: 1
name: Discussions Section Shows Thread List
expected: |
  Navigate to a subscribed community. Tap the "Discussions" segment in the segmented control. A list of discussion threads appears with compact rows showing thread title, author name, tier badge pill (e.g., "Gold"), reply count, like count, and relative timestamp. Threads with a higher tier requirement than your subscription show as locked with a LockedContentOverlay and upgrade prompt.
awaiting: user response

## Tests

### 1. Discussions Section Shows Thread List
expected: Navigate to a subscribed community. Tap the "Discussions" segment in the segmented control. A list of discussion threads appears with compact rows showing thread title, author name, tier badge pill (e.g., "Gold"), reply count, like count, and relative timestamp. Threads with a higher tier requirement than your subscription show as locked with a LockedContentOverlay and upgrade prompt.
result: [pending]

### 2. Thread Detail with Flat Replies
expected: Tap on an accessible (unlocked) thread in the Discussions list. A detail view pushes onto the navigation stack showing the original post at top (author, tier badge, content), followed by a flat chronological list of replies separated by dividers. Each reply shows the author's avatar, name, tier badge, content, and a heart icon with like count.
result: [pending]

### 3. Creator/Ambassador Reply Teal Highlight
expected: In a thread detail view, find a reply from the community creator or ambassador. That reply row should have a subtle teal tint background and a teal "Creator" or "Ambassador" role badge pill next to the tier badge. The creator's avatar should show a verified checkmark. This visual treatment makes creator replies immediately distinguishable from member replies.
result: [pending]

### 4. Like Toggling on Threads and Replies
expected: In the thread list, tap the heart icon on a thread — it should toggle from outline to filled red and the count should increment by 1. Tap again to unlike (count decrements). In thread detail, tap the heart on any reply — same toggle behavior. All updates happen immediately with no loading state.
result: [pending]

### 5. Create New Thread via FAB
expected: In the Discussions section, look for a floating "+" button at the bottom-right. Tap it — a compose sheet appears with Title and Body text fields and a Submit button. Enter a title and body, tap Submit. The sheet dismisses and the new thread appears in the thread list.
result: [pending]

### 6. Reply to a Thread
expected: In a thread detail view, look for a text field at the bottom (chat input style). Type a reply message and tap Send. The reply appears immediately at the bottom of the flat reply list with your name and the current timestamp.
result: [pending]

### 7. Non-Subscriber Sees Locked Discussions
expected: Navigate to a community you are NOT subscribed to. Tap Discussions. All threads should appear locked with blurred content and an upgrade prompt naming the required tier.
result: [pending]

### 8. FAQ Section Shows Accordion List
expected: In a subscribed community, tap the "FAQ" segment. An accordion list appears with answered entries at top (green checkmark icon) and unanswered/pending entries below (clock icon). Tapping an answered entry expands it inline to reveal the answer text with teal tint background and creator attribution. Tapping again collapses it. Only one entry expands at a time.
result: [pending]

### 9. Ask a Question (Tier-Gated)
expected: At the top of the FAQ section, there is an inline "Ask a question..." text field. If your tier has FAQ submission permission, you can type a question and tap Send — it appears in the pending/unanswered section below with a clock icon. If your tier does NOT have permission, the field should be disabled or show an upgrade prompt naming the required tier.
result: [pending]

### 10. Creator Answer Visual Treatment in FAQ
expected: Expand an answered FAQ entry. The answer text should appear with a teal tint background (matching the forum creator highlight pattern), along with the creator's name and a verified badge or "Creator" attribution. This visually distinguishes the official answer from the question.
result: [pending]

## Summary

total: 10
passed: 0
issues: 0
pending: 10
skipped: 0

## Gaps

[none yet]

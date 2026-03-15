---
status: complete
phase: 06-content-feed-and-tier-gated-access
source: [06-01-SUMMARY.md, 06-02-SUMMARY.md]
started: 2026-03-14T20:00:00Z
updated: 2026-03-15T07:30:00Z
---

## Current Test

[testing complete]

## Tests

### 1. Content Feed Renders in Posts Section
expected: Navigate to a subscribed community (subscribe if needed). Tap the "Posts" segment in the segmented control. A content feed appears with post cards showing creator avatar, name, and relative timestamps. Posts appear in reverse chronological order (newest first).
result: pass

### 2. Text Post Card with Read More
expected: In the feed, find a text-only post (no ticker tags, no YouTube thumbnail). If the text is long, it should be truncated to ~4 lines with a "Read more" label. Tapping "Read more" expands the full text inline.
result: pass

### 3. Trade Highlight Card with Ticker Metrics
expected: In the feed, find a trade highlight post. It should show orange stock ticker tag(s) (e.g., "$AAPL", "$RY.TO") and below them a metrics row with the ticker symbol, a mock price (e.g., "$182.50"), and a percentage change (e.g., "+2.3%" in green or "-1.2%" in red). The card should feel visually distinct from plain text posts.
result: pass

### 4. YouTube Link Card with Play Button
expected: In the feed, find a YouTube link post. It should show the post body text, then below it an embedded card with a dark gradient thumbnail, a red circular play button in the center, the video title, and a YouTube icon or "youtube.com" label. The card should be visually distinct as a video link.
result: pass

### 5. YouTube Deep Link Opens External App
expected: Tap the YouTube thumbnail/card on a YouTube link post. It should open the YouTube app (if installed) or Safari. You should leave the Blossom app momentarily.
result: pass

### 6. Locked Post with Blurred Content
expected: Subscribe to a community at the lowest tier. In the feed, look for posts that require a higher tier. These locked posts should show the author row and type indicators (ticker tags if trade highlight) clearly, but the body content should be blurred. A lock icon and "Upgrade to [Tier Name]" prompt with an Upgrade button should appear over the blurred content.
result: pass

### 7. Locked Post Upgrade Opens Tier Sheet
expected: On a locked post, tap the "Upgrade" button. The TiersBottomSheet should appear showing all available tiers for this community, allowing you to upgrade.
result: pass

### 8. Collection Filter Dropdown
expected: In the Posts feed, look for a "Filter: All Posts" dropdown near the top of the feed. Tap it to see a menu of collection categories (e.g., "Trade Alerts", "ETF Deep Dives"). Select one — the feed should narrow to only posts in that collection. Select "All Posts" again to see everything.
result: pass

### 9. Videos Section Shows Only YouTube Posts
expected: Switch to the "Videos" segment in the segmented control. Only YouTube link posts should appear — no text posts, no trade highlights. The collection filter should be hidden since this section is already filtered.
result: pass

### 10. Non-Subscriber Sees All Posts Locked
expected: Navigate to a community you are NOT subscribed to. Tap into the Posts section. ALL posts should appear locked (blurred content, lock overlay, upgrade prompt) since you have no subscription tier.
result: pass

## Summary

total: 10
passed: 10
issues: 0
pending: 0
skipped: 0

## Gaps

[none]

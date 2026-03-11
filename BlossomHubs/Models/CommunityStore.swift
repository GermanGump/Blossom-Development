import Foundation

@MainActor
@Observable
final class CommunityStore {
    var communities: [Community] = CommunityStore.makeMockData()

    static func makeMockData() -> [Community] {
        [
            makeWealthmatica(),
            makeBDInvesting(),
            makeBrandonsAlpha(),
            makeMaxMarkets(),
            makeMoesWatchlist(),
            makeCanadianInvestor()
        ]
    }
}

// MARK: - Nick: Wealthmatica

private extension CommunityStore {
    static func makeWealthmatica() -> Community {
        let creator = Creator(
            name: "Nick",
            username: "@wealthmatica",
            profileImageName: "nick-profile-pic",
            bio: "Canadian dividend investor and personal finance educator. Building wealth one dividend at a time."
        )

        let tiers = [
            Tier(
                name: "Observer",
                monthlyPrice: 0,
                benefits: [
                    "Access to free market commentary",
                    "Monthly newsletter digest",
                    "Community forum (read only)"
                ]
            ),
            Tier(
                name: "Investor",
                monthlyPrice: 19,
                benefits: [
                    "Weekly market commentary",
                    "Canadian dividend stock watchlist",
                    "Community forum (full access)",
                    "Monthly portfolio snapshot"
                ]
            ),
            Tier(
                name: "Pro",
                monthlyPrice: 49,
                benefits: [
                    "Real-time trade alerts",
                    "Monthly portfolio review call",
                    "Direct message access",
                    "All Investor tier benefits",
                    "Exclusive deep-dive research reports"
                ]
            )
        ]

        let posts = [
            Post(
                authorId: creator.id,
                content: "Just added to my $RY.TO position this week. Royal Bank continues to raise dividends — now at 4.2% yield. If you're building a TFSA income portfolio, Canadian banks should be a core holding. Current price is looking attractive near the 200-day MA.",
                postType: .tradeHighlight,
                stockTickers: ["$RY.TO"],
                requiredTierIndex: 0,
                publishedAt: daysAgo(1)
            ),
            Post(
                authorId: creator.id,
                content: "WATCH: My full breakdown of the best dividend ETFs for a TFSA in 2026. I cover VDY, XDIV, and ZWC — showing yield, MER, and 5-year total return side by side.",
                postType: .youtubeLink,
                stockTickers: [],
                youtubeURL: "https://youtube.com/watch?v=example1",
                requiredTierIndex: 0,
                publishedAt: daysAgo(3),
                collection: "ETF Deep Dives"
            ),
            Post(
                authorId: creator.id,
                content: "Pro members: Full position sizing update. I've trimmed $CNQ.TO by 15% and reallocated to $FTS.TO ahead of the rate decision. Here's my full reasoning with entry/exit targets.",
                postType: .tradeHighlight,
                stockTickers: ["$CNQ.TO", "$FTS.TO"],
                requiredTierIndex: 2,
                publishedAt: daysAgo(2),
                collection: "Trade Alerts"
            ),
            Post(
                authorId: creator.id,
                content: "Investor tier update: Updated dividend watchlist is posted. 12 Canadian stocks screened for: yield > 3.5%, payout ratio < 70%, 5+ years of consecutive dividend growth. Link in the resources tab.",
                postType: .text,
                stockTickers: [],
                requiredTierIndex: 1,
                publishedAt: daysAgo(5)
            ),
            Post(
                authorId: creator.id,
                content: "Quick thought on $SHOP.TO: Shopify's Q4 beat was impressive but valuation is stretched at 70x earnings. I'm watching the $95 level as potential support before considering a starter position.",
                postType: .text,
                stockTickers: ["$SHOP.TO"],
                requiredTierIndex: 0,
                publishedAt: daysAgo(7)
            )
        ]

        let threads = [
            ForumThread(
                title: "Best dividend ETFs for 2026?",
                content: "Looking for recommendations on dividend ETFs that work well inside a TFSA. Currently considering VDY and XDIV — what are you all holding?",
                authorId: creator.id,
                requiredTierIndex: 0,
                replyCount: 34,
                likeCount: 67,
                publishedAt: daysAgo(4)
            ),
            ForumThread(
                title: "Canadian bank stocks: BNS vs RY — which would you add here?",
                content: "BNS has underperformed for years but the new CEO is making real changes. RY is a safer pick but priced accordingly. Share your thesis.",
                authorId: creator.id,
                requiredTierIndex: 1,
                replyCount: 22,
                likeCount: 41,
                publishedAt: daysAgo(6)
            ),
            ForumThread(
                title: "Portfolio review - feedback welcome",
                content: "Happy to share my current TFSA allocation and get community feedback. It's 60% dividend stocks, 30% ETFs, 10% REITs.",
                authorId: creator.id,
                requiredTierIndex: 1,
                replyCount: 18,
                likeCount: 29,
                publishedAt: daysAgo(10)
            ),
            ForumThread(
                title: "TFSA contribution room tracking — what tool do you use?",
                content: "CRA My Account is always behind. Anyone using a spreadsheet or app to track contribution room accurately?",
                authorId: creator.id,
                requiredTierIndex: 0,
                replyCount: 45,
                likeCount: 88,
                publishedAt: daysAgo(14)
            )
        ]

        let faqEntries = [
            FAQEntry(
                question: "Do you hold US dividend stocks or only Canadian?",
                answer: "Primarily Canadian for the dividend tax credit benefit inside non-registered accounts, but I hold some US exposure through ETFs like XUS inside my RRSP to avoid withholding tax.",
                isAnswered: true,
                askedBy: "@dividendhunter99",
                answeredBy: "@wealthmatica"
            ),
            FAQEntry(
                question: "What's the minimum portfolio size before dividends become meaningful?",
                answer: "I typically say $50K+ before dividends generate enough monthly income to feel motivating. But compounding works at any level — the habit of reinvesting matters more than the dollar amount early on.",
                isAnswered: true,
                askedBy: "@startingout2026",
                answeredBy: "@wealthmatica"
            ),
            FAQEntry(
                question: "Will you do a full RRSP vs TFSA comparison video this year?",
                answer: nil,
                isAnswered: false,
                askedBy: "@maple_investor",
                answeredBy: nil
            )
        ]

        return Community(
            name: "Wealthmatica",
            description: "Canadian dividend investing, TFSA/RRSP strategy, and passive income building. Join 400+ investors growing wealth the boring (profitable) way.",
            logoImageName: "nick-profile-pic",
            creator: creator,
            tiers: tiers,
            posts: posts,
            threads: threads,
            faqEntries: faqEntries,
            memberCount: 412,
            category: "Dividend Investing"
        )
    }
}

// MARK: - BD: BD Investing

private extension CommunityStore {
    static func makeBDInvesting() -> Community {
        let creator = Creator(
            name: "BD",
            username: "@bdinvesting",
            profileImageName: "bd-profile-pic",
            bio: "Growth investor focused on tech and consumer disruptors. Sharing real trades, real analysis, no fluff."
        )

        let tiers = [
            Tier(
                name: "Basic",
                monthlyPrice: 29.99,
                benefits: [
                    "Weekly growth stock watchlist",
                    "Community forum access",
                    "Monthly market outlook video"
                ]
            ),
            Tier(
                name: "Premium",
                monthlyPrice: 39,
                benefits: [
                    "Real-time trade alerts with entry/exit targets",
                    "Bi-weekly earnings preview breakdowns",
                    "Direct Q&A with BD",
                    "All Basic tier benefits",
                    "Portfolio allocation updates"
                ]
            )
        ]

        let posts = [
            Post(
                authorId: creator.id,
                content: "NVDA is setting up for a textbook bull flag on the weekly. After the earnings beat, we saw a massive volume surge followed by low-volume consolidation. This is classic institutional accumulation. Watching $118 as the breakout trigger.",
                postType: .tradeHighlight,
                stockTickers: ["$NVDA"],
                requiredTierIndex: 0,
                publishedAt: daysAgo(1)
            ),
            Post(
                authorId: creator.id,
                content: "Premium alert: Took a 2% position in $AMD at $178.40. This is a swing trade targeting $195 on the next AI infrastructure spending narrative. Stop at $171. Full trade rationale below.",
                postType: .tradeHighlight,
                stockTickers: ["$AMD"],
                requiredTierIndex: 1,
                publishedAt: daysAgo(2),
                collection: "Trade Alerts"
            ),
            Post(
                authorId: creator.id,
                content: "My 2026 AI watchlist: $NVDA $MSFT $GOOGL $PLTR $SMCI. These are the names I'll be building positions in on any significant pullback. Thread incoming on why each one made the cut.",
                postType: .text,
                stockTickers: ["$NVDA", "$MSFT"],
                requiredTierIndex: 0,
                publishedAt: daysAgo(4)
            ),
            Post(
                authorId: creator.id,
                content: "WATCH: Deep dive on $MSFT Azure growth trajectory and why I think the cloud segment alone justifies current valuation.",
                postType: .youtubeLink,
                stockTickers: ["$MSFT"],
                youtubeURL: "https://youtube.com/watch?v=example2",
                requiredTierIndex: 1,
                publishedAt: daysAgo(6),
                collection: "Stock Deep Dives"
            ),
            Post(
                authorId: creator.id,
                content: "Tech sector rotation update for Premium members: AI infrastructure play shifting toward software layer. Here are the three names I'm moving into.",
                postType: .text,
                stockTickers: [],
                requiredTierIndex: 1,
                publishedAt: daysAgo(8)
            )
        ]

        let threads = [
            ForumThread(
                title: "NVDA earnings play — calls or shares?",
                content: "NVDA reports next week. Implied volatility is elevated. Is it better to just buy shares and hold through earnings, or play the move with options?",
                authorId: creator.id,
                requiredTierIndex: 0,
                replyCount: 56,
                likeCount: 102,
                publishedAt: daysAgo(3)
            ),
            ForumThread(
                title: "Is the AI trade getting crowded?",
                content: "Every fund manager is overweight AI/semiconductors right now. When does the crowded trade become a risk? What's your read on positioning?",
                authorId: creator.id,
                requiredTierIndex: 0,
                replyCount: 38,
                likeCount: 74,
                publishedAt: daysAgo(7)
            ),
            ForumThread(
                title: "Growth vs value in 2026 — where are you positioned?",
                content: "Rising rate fears earlier this year hit growth hard. With rates stabilizing, is it time to rotate back into high-multiple tech?",
                authorId: creator.id,
                requiredTierIndex: 1,
                replyCount: 29,
                likeCount: 55,
                publishedAt: daysAgo(12)
            )
        ]

        let faqEntries = [
            FAQEntry(
                question: "Do you use technical analysis, fundamental analysis, or both?",
                answer: "Both — fundamentals to pick the stock, technicals to time the entry. I never buy a fundamentally great company at a technically terrible price.",
                isAnswered: true,
                askedBy: "@techtrader_22",
                answeredBy: "@bdinvesting"
            ),
            FAQEntry(
                question: "What's your typical position sizing for a trade alert?",
                answer: "I risk 1-2% of portfolio per trade. So on a $100K portfolio, a 2% risk trade means I might put 5-10% in the stock depending on where my stop is.",
                isAnswered: true,
                askedBy: "@riskmanager_pro",
                answeredBy: "@bdinvesting"
            ),
            FAQEntry(
                question: "Will you cover small-cap growth stocks more this year?",
                answer: nil,
                isAnswered: false,
                askedBy: "@smallcap_seeker",
                answeredBy: nil
            )
        ]

        return Community(
            name: "BD Investing",
            description: "Growth stocks, tech analysis, and real trade alerts. No noise, just actionable insights from someone who's in the market every day.",
            logoImageName: "bd-profile-pic",
            creator: creator,
            tiers: tiers,
            posts: posts,
            threads: threads,
            faqEntries: faqEntries,
            memberCount: 287,
            category: "Education & Swing Trading"
        )
    }
}

// MARK: - Brandon: Brandon's Alpha

private extension CommunityStore {
    static func makeBrandonsAlpha() -> Community {
        let creator = Creator(
            name: "Brandon",
            username: "@brandonsalpha",
            profileImageName: "brandon-profile-pic",
            bio: "Options trader and swing trade educator. Turning complex derivatives into simple, actionable strategies."
        )

        let tiers = [
            Tier(
                name: "Free",
                monthlyPrice: 0,
                benefits: [
                    "Weekly options education content",
                    "Community forum (read only)",
                    "Monthly market recap"
                ]
            ),
            Tier(
                name: "Core",
                monthlyPrice: 25,
                benefits: [
                    "Weekly swing trade setups",
                    "Options strategy breakdowns",
                    "Community forum (full access)",
                    "Trade journal access"
                ]
            ),
            Tier(
                name: "Elite",
                monthlyPrice: 75,
                benefits: [
                    "Real-time options flow alerts",
                    "Same-day swing trade entries",
                    "Monthly portfolio review call",
                    "All Core benefits",
                    "Private Discord access"
                ]
            )
        ]

        let posts = [
            Post(
                authorId: creator.id,
                content: "This week's swing setup: $TSLA is coiling below the $240 resistance that's been tested 4 times. A break above on volume would be a high-probability long. I'm watching pre-market Monday. Risk/reward is 1:3 targeting $275.",
                postType: .tradeHighlight,
                stockTickers: ["$TSLA"],
                requiredTierIndex: 1,
                publishedAt: daysAgo(1),
                collection: "Weekly Setups"
            ),
            Post(
                authorId: creator.id,
                content: "Options 101: Why I almost never buy ATM calls before earnings. The implied volatility crush after the event eats your gains even if the stock moves your way. Let me show you the math.",
                postType: .text,
                stockTickers: [],
                requiredTierIndex: 0,
                publishedAt: daysAgo(3),
                collection: "Options Education"
            ),
            Post(
                authorId: creator.id,
                content: "Elite alert: Opened a $AAPL bull put spread — sold the $180/$175 put spread for $1.85 credit. Max profit if $AAPL stays above $180 through expiry. Full breakdown in the trade journal.",
                postType: .tradeHighlight,
                stockTickers: ["$AAPL"],
                requiredTierIndex: 2,
                publishedAt: daysAgo(2),
                collection: "Trade Alerts"
            ),
            Post(
                authorId: creator.id,
                content: "WATCH: My complete guide to reading options chains — open interest, volume, and what unusual activity actually means vs the hype you see on Twitter.",
                postType: .youtubeLink,
                stockTickers: [],
                youtubeURL: "https://youtube.com/watch?v=example3",
                requiredTierIndex: 0,
                publishedAt: daysAgo(5),
                collection: "Options Education"
            ),
            Post(
                authorId: creator.id,
                content: "Core members: Three swing setups I'm watching next week — $NVDA at the 50-day, $MSFT breakout from consolidation, $META testing prior highs. Detailed charts in the resources tab.",
                postType: .tradeHighlight,
                stockTickers: ["$NVDA", "$MSFT"],
                requiredTierIndex: 1,
                publishedAt: daysAgo(7)
            ),
            Post(
                authorId: creator.id,
                content: "Reminder: The best trades are boring. If you're chasing penny stocks and meme plays, you're gambling, not trading. Discipline and process beat excitement every time.",
                postType: .text,
                stockTickers: [],
                requiredTierIndex: 0,
                publishedAt: daysAgo(9)
            )
        ]

        let threads = [
            ForumThread(
                title: "Options vs shares for TSLA — what's your preferred vehicle?",
                content: "TSLA's volatility makes it great for options, but the wide spreads can eat into profits. When does it make sense to just buy shares instead?",
                authorId: creator.id,
                requiredTierIndex: 0,
                replyCount: 47,
                likeCount: 91,
                publishedAt: daysAgo(2)
            ),
            ForumThread(
                title: "Best swing trade setups in sideways markets?",
                content: "When the market is ranging, trend-following setups fail constantly. What strategies work best for you in choppy, low-trend environments?",
                authorId: creator.id,
                requiredTierIndex: 1,
                replyCount: 31,
                likeCount: 58,
                publishedAt: daysAgo(8)
            ),
            ForumThread(
                title: "How do you manage a losing trade emotionally?",
                content: "The psychology of trading is 80% of the game. Share how you handle drawdowns, stop losses hit, and staying disciplined when a thesis is wrong.",
                authorId: creator.id,
                requiredTierIndex: 0,
                replyCount: 63,
                likeCount: 129,
                publishedAt: daysAgo(15)
            ),
            ForumThread(
                title: "Paper trading vs live money — when to make the switch?",
                content: "I know the textbook answer is 'paper trade until consistently profitable' but paper trading doesn't replicate the emotional pressure. Thoughts?",
                authorId: creator.id,
                requiredTierIndex: 0,
                replyCount: 42,
                likeCount: 77,
                publishedAt: daysAgo(20)
            )
        ]

        let faqEntries = [
            FAQEntry(
                question: "Do you recommend a specific broker for options trading in Canada?",
                answer: "I use Questrade for registered accounts and Interactive Brokers for active trading. IBKR has the best options tools and lowest commissions for active traders.",
                isAnswered: true,
                askedBy: "@canuck_trader",
                answeredBy: "@brandonsalpha"
            ),
            FAQEntry(
                question: "What's the minimum account size you'd recommend before trading options?",
                answer: "I'd say $25K minimum. Below that, commissions eat too much of your P&L and you can't properly size positions to manage risk. Use the time below $25K to paper trade and learn.",
                isAnswered: true,
                askedBy: "@newbie_options",
                answeredBy: "@brandonsalpha"
            ),
            FAQEntry(
                question: "Do you cover covered calls and cash-secured puts for income generation?",
                answer: "Yes! That's actually a major focus for Core members — selling premium as an income strategy on stocks you'd own anyway.",
                isAnswered: true,
                askedBy: "@income_seeker_2026",
                answeredBy: "@brandonsalpha"
            )
        ]

        return Community(
            name: "Brandon's Alpha",
            description: "Options strategies and swing trading for serious traders. From covered calls to complex spreads, learn to trade derivatives with discipline.",
            logoImageName: "brandon-profile-pic",
            creator: creator,
            tiers: tiers,
            posts: posts,
            threads: threads,
            faqEntries: faqEntries,
            memberCount: 178,
            category: "Options & Swing Trading"
        )
    }
}

// MARK: - Max: Max Markets

private extension CommunityStore {
    static func makeMaxMarkets() -> Community {
        let creator = Creator(
            name: "Max",
            username: "@maxmarkets",
            profileImageName: "max-profile-pic",
            bio: "Passive investor and index fund advocate. Helping regular people beat most active fund managers by doing less."
        )

        let tiers = [
            Tier(
                name: "Member",
                monthlyPrice: 9,
                benefits: [
                    "Monthly passive investing newsletter",
                    "Model portfolio allocations",
                    "Community forum access"
                ]
            ),
            Tier(
                name: "Analyst",
                monthlyPrice: 29,
                benefits: [
                    "Quarterly portfolio rebalancing guide",
                    "Factor investing deep dives",
                    "Asset allocation Q&A sessions",
                    "All Member benefits",
                    "Annual financial plan template"
                ]
            )
        ]

        let posts = [
            Post(
                authorId: creator.id,
                content: "The data is clear: over any 20-year period, a simple 3-fund portfolio (total market, international, bonds) beats 85% of active funds after fees. Stop overcomplicating it. Here's the exact allocation I recommend for different risk profiles.",
                postType: .text,
                stockTickers: [],
                requiredTierIndex: 0,
                publishedAt: daysAgo(2)
            ),
            Post(
                authorId: creator.id,
                content: "WATCH: I compared 10 robo-advisors against a DIY index fund strategy over 5 years. The results might surprise you — some robos actually beat DIY on risk-adjusted returns once you factor in behaviour.",
                postType: .youtubeLink,
                stockTickers: [],
                youtubeURL: "https://youtube.com/watch?v=example4",
                requiredTierIndex: 0,
                publishedAt: daysAgo(5),
                collection: "Research"
            ),
            Post(
                authorId: creator.id,
                content: "Q1 rebalancing update for Analyst members: With equities up 8% YTD, most balanced portfolios are overweight stocks. Here's my step-by-step rebalancing guide for different account types (TFSA, RRSP, margin).",
                postType: .text,
                stockTickers: [],
                requiredTierIndex: 1,
                publishedAt: daysAgo(3),
                collection: "Rebalancing Guides"
            ),
            Post(
                authorId: creator.id,
                content: "The fee drag is real: A 1% MER difference compounded over 30 years on a $500K portfolio costs you $430,000. This is why I'll never stop talking about low-cost index funds.",
                postType: .text,
                stockTickers: [],
                requiredTierIndex: 0,
                publishedAt: daysAgo(8)
            )
        ]

        let threads = [
            ForumThread(
                title: "XEQT vs VEQT — which all-equity ETF do you prefer?",
                content: "Both are excellent but have different US/Canada/International weightings. Which do you hold and why? Looking to simplify to a single ETF.",
                authorId: creator.id,
                requiredTierIndex: 0,
                replyCount: 71,
                likeCount: 143,
                publishedAt: daysAgo(4)
            ),
            ForumThread(
                title: "International diversification: how much is enough?",
                content: "Some argue 20% international is fine, others say 40%+. With home country bias being real, how do you think about international allocation?",
                authorId: creator.id,
                requiredTierIndex: 1,
                replyCount: 29,
                likeCount: 52,
                publishedAt: daysAgo(9)
            ),
            ForumThread(
                title: "Bond allocation in your 30s — is it even worth it?",
                content: "The traditional age-in-bonds rule seems outdated with longer life expectancies. Are bonds necessary before 50 for someone with stable income?",
                authorId: creator.id,
                requiredTierIndex: 0,
                replyCount: 38,
                likeCount: 68,
                publishedAt: daysAgo(13)
            )
        ]

        let faqEntries = [
            FAQEntry(
                question: "Do you ever recommend individual stocks, or only ETFs?",
                answer: "Almost always ETFs. I might hold a small individual stock allocation (5% or less) for fun, but I never recommend individual stocks as a core strategy. The evidence against stock picking is overwhelming.",
                isAnswered: true,
                askedBy: "@index_curious",
                answeredBy: "@maxmarkets"
            ),
            FAQEntry(
                question: "What do you think of the 4% withdrawal rule for early retirement?",
                answer: "Reasonable starting point, but I think 3.5% is safer for early retirees with a 40+ year horizon. The original Trinity Study didn't account for sequence-of-returns risk over very long periods.",
                isAnswered: true,
                askedBy: "@fire_seeker_canada",
                answeredBy: "@maxmarkets"
            ),
            FAQEntry(
                question: "Will you do a comparison of WealthSimple vs Questrade for passive investing?",
                answer: nil,
                isAnswered: false,
                askedBy: "@platform_shopper",
                answeredBy: nil
            )
        ]

        return Community(
            name: "Max Markets",
            description: "Index funds, passive investing, and evidence-based wealth building. Boring strategies that consistently outperform the experts.",
            logoImageName: "max-profile-pic",
            creator: creator,
            tiers: tiers,
            posts: posts,
            threads: threads,
            faqEntries: faqEntries,
            memberCount: 356,
            category: "Passive Investing"
        )
    }
}

// MARK: - Moe: Moe's Watchlist

private extension CommunityStore {
    static func makeMoesWatchlist() -> Community {
        let creator = Creator(
            name: "Moe",
            username: "@moeswatchlist",
            profileImageName: "moe-profile-pic",
            bio: "Momentum trader specializing in small-cap breakouts and high-growth stocks. High risk, high reward."
        )

        let tiers = [
            Tier(
                name: "Observer",
                monthlyPrice: 0,
                benefits: [
                    "Weekly momentum scan results",
                    "Community forum (read only)"
                ]
            ),
            Tier(
                name: "Member",
                monthlyPrice: 15,
                benefits: [
                    "Daily small-cap watchlist",
                    "Breakout setup analysis",
                    "Community forum (full access)",
                    "Weekly market breadth report"
                ]
            ),
            Tier(
                name: "Pro",
                monthlyPrice: 45,
                benefits: [
                    "Intraday momentum alerts",
                    "Pre-market gap-up scanner results",
                    "All Member benefits",
                    "Monthly risk management workshop"
                ]
            ),
            Tier(
                name: "VIP",
                monthlyPrice: 100,
                benefits: [
                    "Direct Telegram group with Moe",
                    "Same-day entry alerts with position sizing",
                    "All Pro benefits",
                    "Quarterly strategy session (1-on-1)",
                    "P&L tracking spreadsheet template"
                ]
            )
        ]

        let posts = [
            Post(
                authorId: creator.id,
                content: "Today's momentum scan flagged 3 small-caps with unusual volume: $SOUN $REAI $IONQ. All three are breaking above 52-week highs on 3x average volume. This is the setup I look for — not chasing, just noting the tape.",
                postType: .tradeHighlight,
                stockTickers: ["$SOUN", "$IONQ"],
                requiredTierIndex: 1,
                publishedAt: daysAgo(1),
                collection: "Daily Watchlist"
            ),
            Post(
                authorId: creator.id,
                content: "VIP alert: Entered $AMD small position at the open — gap and go setup off earnings gap fill. Target is the prior high at $198. Tight stop at yesterday's low. This is a 1-day or overnight hold only.",
                postType: .tradeHighlight,
                stockTickers: ["$AMD"],
                requiredTierIndex: 3,
                publishedAt: daysAgo(1),
                collection: "VIP Alerts"
            ),
            Post(
                authorId: creator.id,
                content: "Momentum is a real, documented market anomaly — stocks that have outperformed over the past 3-12 months tend to continue outperforming. Here's the academic backing and how I apply it practically.",
                postType: .text,
                stockTickers: [],
                requiredTierIndex: 0,
                publishedAt: daysAgo(4),
                collection: "Education"
            ),
            Post(
                authorId: creator.id,
                content: "WATCH: My full small-cap scanner setup — the exact filters I use in Finviz to find breakout candidates before they make their move.",
                postType: .youtubeLink,
                stockTickers: [],
                youtubeURL: "https://youtube.com/watch?v=example5",
                requiredTierIndex: 1,
                publishedAt: daysAgo(6),
                collection: "Education"
            ),
            Post(
                authorId: creator.id,
                content: "Pro members: Market breadth update. NYSE advance/decline line is making new highs even as large-cap indices stall. This is a bullish divergence for small-caps. Increasing exposure.",
                postType: .text,
                stockTickers: [],
                requiredTierIndex: 2,
                publishedAt: daysAgo(3)
            )
        ]

        let threads = [
            ForumThread(
                title: "Best scanners for small-cap momentum plays?",
                content: "I've tried Finviz, Trade Ideas, and TC2000. What's your go-to for finding the setups Moe talks about? Looking for real-time scanning.",
                authorId: creator.id,
                requiredTierIndex: 1,
                replyCount: 52,
                likeCount: 98,
                publishedAt: daysAgo(3)
            ),
            ForumThread(
                title: "How do you handle overnight risk on momentum trades?",
                content: "Gap risk is the killer with small-caps. Do you hold overnight positions, or is everything day-traded? What's your framework?",
                authorId: creator.id,
                requiredTierIndex: 1,
                replyCount: 34,
                likeCount: 61,
                publishedAt: daysAgo(7)
            ),
            ForumThread(
                title: "Momentum vs mean reversion — can you mix both?",
                content: "I've been trying to combine momentum breakout entries with mean reversion exits (selling into strength). Anyone had success with a hybrid approach?",
                authorId: creator.id,
                requiredTierIndex: 2,
                replyCount: 19,
                likeCount: 37,
                publishedAt: daysAgo(12)
            ),
            ForumThread(
                title: "Managing your PDT (Pattern Day Trader) rule restrictions",
                content: "Under $25K accounts get crushed by PDT. What workarounds have you found — cash accounts, multiple brokers, Canadian accounts?",
                authorId: creator.id,
                requiredTierIndex: 0,
                replyCount: 67,
                likeCount: 124,
                publishedAt: daysAgo(18)
            )
        ]

        let faqEntries = [
            FAQEntry(
                question: "Do you ever hold positions longer than a week?",
                answer: "Rarely. My sweet spot is 1-5 days. Momentum works best in that window — too short and you're pure noise, too long and you're fighting against mean reversion.",
                isAnswered: true,
                askedBy: "@swing_momentum",
                answeredBy: "@moeswatchlist"
            ),
            FAQEntry(
                question: "What's your win rate on the small-cap setups?",
                answer: "Honestly, around 45-50%. The edge isn't in a high win rate — it's in the risk/reward. My winners average 3:1 against my losers. You can be right less than half the time and still be very profitable.",
                isAnswered: true,
                askedBy: "@winrate_curious",
                answeredBy: "@moeswatchlist"
            ),
            FAQEntry(
                question: "Do you cover Canadian small-caps on the TSX Venture?",
                answer: nil,
                isAnswered: false,
                askedBy: "@venture_watcher",
                answeredBy: nil
            )
        ]

        return Community(
            name: "Moe's Watchlist",
            description: "Momentum trading, small-cap breakouts, and aggressive growth. For traders who want real edge in fast-moving markets.",
            logoImageName: "moe-profile-pic",
            creator: creator,
            tiers: tiers,
            posts: posts,
            threads: threads,
            faqEntries: faqEntries,
            memberCount: 98,
            category: "Momentum Trading"
        )
    }
}

// MARK: - Canadian in a T-shirt: Canadian Investor

private extension CommunityStore {
    static func makeCanadianInvestor() -> Community {
        let creator = Creator(
            name: "Canadian in a T-shirt",
            username: "@canadianinatshirt",
            profileImageName: "canada-tshirt-profile-pic",
            bio: "Helping everyday Canadians understand TFSA, RRSP, and TSX investing. No suits, no jargon, just real talk."
        )

        let tiers = [
            Tier(
                name: "Basic",
                monthlyPrice: 5,
                benefits: [
                    "Monthly Canadian market newsletter",
                    "TFSA/RRSP tip of the week",
                    "Community forum access"
                ]
            ),
            Tier(
                name: "Investor",
                monthlyPrice: 20,
                benefits: [
                    "Weekly TSX stock picks",
                    "Registered account optimization guides",
                    "All Basic benefits",
                    "Monthly live Q&A session"
                ]
            ),
            Tier(
                name: "Mentor Circle",
                monthlyPrice: 60,
                benefits: [
                    "Monthly 1-on-1 portfolio review call",
                    "Personalized TFSA/RRSP strategy",
                    "All Investor benefits",
                    "Private group with direct access",
                    "Annual tax optimization checklist"
                ]
            )
        ]

        let posts = [
            Post(
                authorId: creator.id,
                content: "2026 TFSA contribution limit is $7,000 — have you maxed it yet? If you turned 18 in 2009 or earlier, your total room is $102,000. For most people, filling your TFSA before your RRSP is the right move. Here's why.",
                postType: .text,
                stockTickers: [],
                requiredTierIndex: 0,
                publishedAt: daysAgo(2)
            ),
            Post(
                authorId: creator.id,
                content: "My pick this week: $RY.TO — Royal Bank of Canada. It's boring, it pays a great dividend, and it's been raising it for 10+ years. If you want 'safe and growing' for a TFSA, this is the archetype. Current yield: 4.1%.",
                postType: .tradeHighlight,
                stockTickers: ["$RY.TO"],
                requiredTierIndex: 1,
                publishedAt: daysAgo(1),
                collection: "Weekly TSX Pick"
            ),
            Post(
                authorId: creator.id,
                content: "WATCH: I built a $0 to $100K TFSA portfolio from scratch using only TSX stocks — here's exactly what I bought, when, and why. Real numbers, real account.",
                postType: .youtubeLink,
                stockTickers: [],
                youtubeURL: "https://youtube.com/watch?v=example6",
                requiredTierIndex: 0,
                publishedAt: daysAgo(5),
                collection: "TFSA Series"
            ),
            Post(
                authorId: creator.id,
                content: "Mentor Circle update: Completed 8 portfolio reviews this month. Common theme I'm seeing — people holding too much cash in their TFSA earning 3% HISA when they could be in $SHOP.TO or index ETFs. Time in market > timing the market.",
                postType: .text,
                stockTickers: ["$SHOP.TO"],
                requiredTierIndex: 2,
                publishedAt: daysAgo(4),
                collection: "Mentor Notes"
            ),
            Post(
                authorId: creator.id,
                content: "Hot take: The RRSP Home Buyers' Plan is underutilized. If you're saving for a first home, withdrawing up to $35,000 from your RRSP interest-free (with 15 years to repay) is one of the best deals in Canadian tax law.",
                postType: .text,
                stockTickers: [],
                requiredTierIndex: 0,
                publishedAt: daysAgo(9)
            )
        ]

        let threads = [
            ForumThread(
                title: "TFSA vs RRSP — which should I max first?",
                content: "I hear different answers from everyone. My income is $85K and I have $20K to invest. Should I prioritize my TFSA, RRSP, or split between them?",
                authorId: creator.id,
                requiredTierIndex: 0,
                replyCount: 89,
                likeCount: 167,
                publishedAt: daysAgo(3)
            ),
            ForumThread(
                title: "Best Canadian dividend stocks for a TFSA in 2026?",
                content: "Building a dividend-focused TFSA. Considering RY, TD, ENB, FTS, and BCE. Any others I should be looking at? Trying to diversify across sectors.",
                authorId: creator.id,
                requiredTierIndex: 1,
                replyCount: 54,
                likeCount: 103,
                publishedAt: daysAgo(6)
            ),
            ForumThread(
                title: "Anyone using WealthSimple Trade for their TFSA?",
                content: "Thinking of switching from my bank's mutual funds to WealthSimple for ETF investing. Worried about the interface and whether it's good for registered accounts.",
                authorId: creator.id,
                requiredTierIndex: 0,
                replyCount: 76,
                likeCount: 142,
                publishedAt: daysAgo(10)
            )
        ]

        let faqEntries = [
            FAQEntry(
                question: "Can I hold US stocks in my TFSA?",
                answer: "Yes, but there's a catch — US dividends are subject to 15% withholding tax even inside a TFSA (the US-Canada tax treaty doesn't cover TFSAs). For US dividend stocks, hold them in your RRSP instead. For US growth stocks with no dividends, TFSA is fine.",
                isAnswered: true,
                askedBy: "@us_stocks_canada",
                answeredBy: "@canadianinatshirt"
            ),
            FAQEntry(
                question: "What happens if I over-contribute to my TFSA?",
                answer: "CRA charges 1% per month on the over-contribution amount. It's not the end of the world but fix it immediately — withdraw the excess and don't re-contribute until the next calendar year.",
                isAnswered: true,
                askedBy: "@tfsa_mistake",
                answeredBy: "@canadianinatshirt"
            ),
            FAQEntry(
                question: "Do you cover FHSA (First Home Savings Account)?",
                answer: "Absolutely — I'll be doing a deep dive on FHSA strategy this month. It's the best new registered account since the TFSA launched.",
                isAnswered: true,
                askedBy: "@fhsa_curious",
                answeredBy: "@canadianinatshirt"
            )
        ]

        return Community(
            name: "Canadian Investor",
            description: "TFSA, RRSP, FHSA, and TSX investing explained in plain language. For everyday Canadians who want to stop leaving money on the table.",
            logoImageName: "canada-tshirt-profile-pic",
            creator: creator,
            tiers: tiers,
            posts: posts,
            threads: threads,
            faqEntries: faqEntries,
            memberCount: 503,
            category: "Canadian Personal Finance"
        )
    }
}

// MARK: - Date helpers

private extension CommunityStore {
    static func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
    }
}

import Foundation

enum CategoryMockData {
    static func communities(for displayCategory: String) -> [Community] {
        switch displayCategory {
        case "Dividend Hubs": return dividendMocks
        case "Value Investing Hubs": return valueInvestingMocks
        case "Trading Hubs": return tradingMocks
        case "Canadian Investing Hubs": return canadianMocks
        default: return []
        }
    }

    // MARK: - Dividend Hubs

    private static let dividendMocks: [Community] = [
        Community(
            name: "DividendGrowth Pro",
            description: "Building generational wealth through dividend growth investing. DRIP strategies, aristocrat analysis, and monthly portfolio reviews.",
            logoImageName: "person.circle",
            creator: Creator(
                name: "Sarah Mitchell",
                username: "@dividendgrowthpro",
                profileImageName: "person.circle",
                isVerified: false,
                isAmbassador: false,
                bio: "15+ years of dividend investing. Financial planner turned educator."
            ),
            tiers: [
                Tier(name: "Free", monthlyPrice: 0, benefits: ["Weekly market recap"], colorHex: "10B981"),
                Tier(name: "Growth", monthlyPrice: 12, benefits: ["Full portfolio access", "Monthly stock picks"], colorHex: "3B82F6"),
            ],
            posts: [], threads: [], faqEntries: [],
            memberCount: 892,
            category: "Dividend Investing"
        ),
        Community(
            name: "Yield Hunters",
            description: "High-yield dividend stocks, REITs, and income-focused ETFs. Weekly watchlists and real-time alerts for income investors.",
            logoImageName: "person.circle",
            creator: Creator(
                name: "James Park",
                username: "@yieldhunters",
                profileImageName: "person.circle",
                isVerified: false,
                isAmbassador: false,
                bio: "Income-focused investor. Retired at 45 on dividends alone."
            ),
            tiers: [
                Tier(name: "Observer", monthlyPrice: 0, benefits: ["Market commentary"], colorHex: "10B981"),
                Tier(name: "Hunter", monthlyPrice: 15, benefits: ["Watchlists", "Yield alerts"], colorHex: "F97316"),
            ],
            posts: [], threads: [], faqEntries: [],
            memberCount: 634,
            category: "Dividend Investing"
        ),
        Community(
            name: "DRIP Nation",
            description: "All about dividend reinvestment plans. Track compound growth, compare DRIP performance, and connect with long-term holders.",
            logoImageName: "person.circle",
            creator: Creator(
                name: "Michael Torres",
                username: "@dripnation",
                profileImageName: "person.circle",
                isVerified: false,
                isAmbassador: false,
                bio: "DRIP investor since 2008. Compounding is the 8th wonder."
            ),
            tiers: [
                Tier(name: "Free", monthlyPrice: 0, benefits: ["Community access"], colorHex: "10B981"),
                Tier(name: "Compounder", monthlyPrice: 8, benefits: ["DRIP tracker", "Monthly deep dives"], colorHex: "6366F1"),
            ],
            posts: [], threads: [], faqEntries: [],
            memberCount: 421,
            category: "Dividend Investing"
        ),
    ]

    // MARK: - Value Investing Hubs

    private static let valueInvestingMocks: [Community] = [
        Community(
            name: "Deep Value Alpha",
            description: "Fundamental analysis, intrinsic value calculations, and contrarian picks. We buy what Wall Street ignores.",
            logoImageName: "person.circle",
            creator: Creator(
                name: "Robert Chen",
                username: "@deepvaluealpha",
                profileImageName: "person.circle",
                isVerified: false,
                isAmbassador: false,
                bio: "CFA charterholder. Value investor inspired by Buffett and Munger."
            ),
            tiers: [
                Tier(name: "Reader", monthlyPrice: 0, benefits: ["Weekly essay"], colorHex: "10B981"),
                Tier(name: "Analyst", monthlyPrice: 20, benefits: ["DCF models", "Full thesis access", "Q&A sessions"], colorHex: "7C3AED"),
            ],
            posts: [], threads: [], faqEntries: [],
            memberCount: 1203,
            category: "Passive Investing"
        ),
        Community(
            name: "Bogle's Corner",
            description: "Index fund investing, asset allocation, and the power of staying the course. Low-cost, long-term, life-changing.",
            logoImageName: "person.circle",
            creator: Creator(
                name: "Amanda Wright",
                username: "@boglescorner",
                profileImageName: "person.circle",
                isVerified: false,
                isAmbassador: false,
                bio: "Passive investing advocate. Keep it simple, keep it cheap."
            ),
            tiers: [
                Tier(name: "Free", monthlyPrice: 0, benefits: ["Community forum"], colorHex: "10B981"),
                Tier(name: "Advisor", monthlyPrice: 7, benefits: ["Portfolio templates", "Rebalancing alerts"], colorHex: "14B8A6"),
            ],
            posts: [], threads: [], faqEntries: [],
            memberCount: 756,
            category: "Passive Investing"
        ),
        Community(
            name: "Margin of Safety",
            description: "Graham-style value investing for the modern market. Earnings quality, balance sheet strength, and patience.",
            logoImageName: "person.circle",
            creator: Creator(
                name: "David Okonkwo",
                username: "@marginofsafety",
                profileImageName: "person.circle",
                isVerified: false,
                isAmbassador: false,
                bio: "Portfolio manager. If you can't explain the thesis in 3 sentences, don't buy it."
            ),
            tiers: [
                Tier(name: "Free", monthlyPrice: 0, benefits: ["Monthly letter"], colorHex: "10B981"),
                Tier(name: "Investor", monthlyPrice: 18, benefits: ["Screener access", "Conviction picks"], colorHex: "3B82F6"),
            ],
            posts: [], threads: [], faqEntries: [],
            memberCount: 589,
            category: "Passive Investing"
        ),
    ]

    // MARK: - Trading Hubs

    private static let tradingMocks: [Community] = [
        Community(
            name: "Scalp Kings",
            description: "Day trading and scalping strategies for futures and equities. Live market commentary during open hours.",
            logoImageName: "person.circle",
            creator: Creator(
                name: "Tyler Reeves",
                username: "@scalpkings",
                profileImageName: "person.circle",
                isVerified: false,
                isAmbassador: false,
                bio: "Full-time day trader. ES and NQ futures specialist."
            ),
            tiers: [
                Tier(name: "Spectator", monthlyPrice: 0, benefits: ["End of day recaps"], colorHex: "10B981"),
                Tier(name: "Trader", monthlyPrice: 35, benefits: ["Live alerts", "Screen sharing", "Playbook access"], colorHex: "F43F5E"),
            ],
            posts: [], threads: [], faqEntries: [],
            memberCount: 1547,
            category: "Momentum Trading"
        ),
        Community(
            name: "Options Flow",
            description: "Unusual options activity, flow analysis, and high-probability setups. Covered calls to iron condors.",
            logoImageName: "person.circle",
            creator: Creator(
                name: "Priya Sharma",
                username: "@optionsflow",
                profileImageName: "person.circle",
                isVerified: false,
                isAmbassador: false,
                bio: "Options trader and educator. Selling premium since 2016."
            ),
            tiers: [
                Tier(name: "Free", monthlyPrice: 0, benefits: ["Weekly flow summary"], colorHex: "10B981"),
                Tier(name: "Premium", monthlyPrice: 29, benefits: ["Daily flow alerts", "Trade journal", "Greeks workshop"], colorHex: "F59E0B"),
            ],
            posts: [], threads: [], faqEntries: [],
            memberCount: 983,
            category: "Options & Swing Trading"
        ),
        Community(
            name: "Swing Setup Daily",
            description: "Multi-day swing trade setups with clear entries, stops, and targets. Technical analysis for busy professionals.",
            logoImageName: "person.circle",
            creator: Creator(
                name: "Kevin Liu",
                username: "@swingsetupdaily",
                profileImageName: "person.circle",
                isVerified: false,
                isAmbassador: false,
                bio: "Part-time swing trader, full-time engineer. Charts don't lie."
            ),
            tiers: [
                Tier(name: "Free", monthlyPrice: 0, benefits: ["Weekend watchlist"], colorHex: "10B981"),
                Tier(name: "Swing Pro", monthlyPrice: 22, benefits: ["Daily setups", "Position sizing guide"], colorHex: "6366F1"),
            ],
            posts: [], threads: [], faqEntries: [],
            memberCount: 712,
            category: "Swing Trading"
        ),
        Community(
            name: "Crypto Momentum",
            description: "Momentum plays in crypto markets. Altcoin breakouts, Bitcoin technical levels, and on-chain analysis.",
            logoImageName: "person.circle",
            creator: Creator(
                name: "Alex Petrov",
                username: "@cryptomomentum",
                profileImageName: "person.circle",
                isVerified: false,
                isAmbassador: false,
                bio: "Crypto native since 2017. On-chain data meets technical analysis."
            ),
            tiers: [
                Tier(name: "Free", monthlyPrice: 0, benefits: ["Weekly outlook"], colorHex: "10B981"),
                Tier(name: "Alpha", monthlyPrice: 25, benefits: ["Real-time alerts", "On-chain dashboard"], colorHex: "F97316"),
            ],
            posts: [], threads: [], faqEntries: [],
            memberCount: 1891,
            category: "Momentum Trading"
        ),
    ]

    // MARK: - Canadian Investing Hubs

    private static let canadianMocks: [Community] = [
        Community(
            name: "TFSA Maximizer",
            description: "Get the most out of your Tax-Free Savings Account. Contribution room tracking, optimal holdings, and tax-efficient strategies.",
            logoImageName: "person.circle",
            creator: Creator(
                name: "Rachel Leblanc",
                username: "@tfsamaximizer",
                profileImageName: "person.circle",
                isVerified: false,
                isAmbassador: false,
                bio: "Canadian tax specialist and TFSA optimization enthusiast."
            ),
            tiers: [
                Tier(name: "Free", monthlyPrice: 0, benefits: ["TFSA basics guide"], colorHex: "10B981"),
                Tier(name: "Optimizer", monthlyPrice: 10, benefits: ["Portfolio templates", "Contribution tracker", "Tax tips"], colorHex: "F43F5E"),
            ],
            posts: [], threads: [], faqEntries: [],
            memberCount: 1124,
            category: "Canadian Personal Finance"
        ),
        Community(
            name: "TSX Dividend Watch",
            description: "Canadian dividend stocks on the TSX. Bank stocks, pipelines, telecoms, and utilities. Built for Canadian income investors.",
            logoImageName: "person.circle",
            creator: Creator(
                name: "Mark Nguyen",
                username: "@tsxdividendwatch",
                profileImageName: "person.circle",
                isVerified: false,
                isAmbassador: false,
                bio: "Canadian dividend investor. Big 5 banks and pipelines forever."
            ),
            tiers: [
                Tier(name: "Free", monthlyPrice: 0, benefits: ["Monthly dividend calendar"], colorHex: "10B981"),
                Tier(name: "Income", monthlyPrice: 8, benefits: ["TSX picks", "Yield comparisons", "Earnings coverage"], colorHex: "3B82F6"),
            ],
            posts: [], threads: [], faqEntries: [],
            memberCount: 673,
            category: "Canadian Personal Finance"
        ),
        Community(
            name: "RRSP & FHSA Guide",
            description: "Navigate RRSP contributions, FHSA for first-time buyers, and retirement withdrawal strategies. Plain language, no jargon.",
            logoImageName: "person.circle",
            creator: Creator(
                name: "Lisa Campbell",
                username: "@rrspfhsaguide",
                profileImageName: "person.circle",
                isVerified: false,
                isAmbassador: false,
                bio: "Certified financial planner in Toronto. Making retirement planning accessible."
            ),
            tiers: [
                Tier(name: "Free", monthlyPrice: 0, benefits: ["Guides and calculators"], colorHex: "10B981"),
                Tier(name: "Planner", monthlyPrice: 12, benefits: ["1-on-1 Q&A", "Custom scenarios", "Tax season prep"], colorHex: "7C3AED"),
            ],
            posts: [], threads: [], faqEntries: [],
            memberCount: 445,
            category: "Canadian Personal Finance"
        ),
    ]
}

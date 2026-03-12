import SwiftUI
import UIKit
import ComponentsKit

@main
struct BlossomHubsApp: App {
    @State private var store = CommunityStore()
    @State private var subscriptionStore = SubscriptionStore()

    init() {
        // Suppress iOS 26 Liquid Glass on native tab bar (belt-and-suspenders with custom tab bar)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance

        #if DEBUG
        // Verify Inter font files are correctly bundled and registered.
        // If any assertion fires, check UIAppFonts in Info.plist and
        // that the .otf files are in the Copy Bundle Resources build phase.
        assert(UIFont(name: "Inter-Regular", size: 17) != nil,
               "Inter-Regular font not loaded — check UIAppFonts in Info.plist")
        assert(UIFont(name: "Inter-Medium", size: 17) != nil,
               "Inter-Medium font not loaded — check UIAppFonts in Info.plist")
        assert(UIFont(name: "Inter-SemiBold", size: 17) != nil,
               "Inter-SemiBold font not loaded — check UIAppFonts in Info.plist")
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
                .environment(subscriptionStore)
                .task {
                    #if DEBUG
                    assert(store.communities.count >= 3,
                           "Mock data should have at least 3 communities")
                    #endif
                }
        }
    }
}

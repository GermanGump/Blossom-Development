import SwiftUI
import ComponentsKit

@main
struct BlossomHubsApp: App {
    init() {
        // Suppress iOS 26 Liquid Glass on native tab bar (belt-and-suspenders with custom tab bar)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light) // Default to light mode for demo
        }
    }
}

import SwiftUI
import ComposableArchitecture

@main
struct StopwatchApp: App {
    var body: some Scene {
        WindowGroup {
            StopwatchView(store: Store(initialState: StopwatchFeature.State()) {
                StopwatchFeature()
            })
        }
    }
}

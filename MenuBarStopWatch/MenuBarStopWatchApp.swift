import SwiftUI

/// The main entry point for the application.
/// Sets up the menu bar extra with the stopwatch UI.
@main
struct MenuBarStopWatchApp: App {
    /// Create and maintain the StopwatchController as a state object
    /// to ensure it persists throughout the app's lifecycle.
    @StateObject private var stopwatchController = StopwatchController()

    var body: some Scene {
        // Create a menu bar extra item with a dropdown menu
        MenuBarExtra {
            // The dropdown content when clicking the menu bar item
            ContentView()
                .environmentObject(stopwatchController)
        } label: {
            // The view shown in the menu bar
            MenuBarLabelView()
                .environmentObject(stopwatchController)
        }
        .menuBarExtraStyle(.window)
    }
}

/// The view displayed in the menu bar showing the current stopwatch time.
struct MenuBarLabelView: View {
    /// Observes the stopwatch controller to update when time changes.
    @EnvironmentObject var stopwatchController: StopwatchController
    
    var body: some View {
        Text(stopwatchController.currentTime)
            .font(.system(.body, design: .monospaced))
    }
}

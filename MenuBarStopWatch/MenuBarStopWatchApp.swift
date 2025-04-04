import SwiftUI

@main
struct MenuBarStopWatchApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(appDelegate)
        } label: {
            MenuBarLabelView(appDelegate: appDelegate)
        }
        .menuBarExtraStyle(.window)
    }
}

// New view to observe AppDelegate
struct MenuBarLabelView: View {
    @ObservedObject var appDelegate: AppDelegate // Observe changes here
    
    var body: some View {
        Text(appDelegate.currentTime)
            .font(.system(.body, design: .monospaced))
    }
}

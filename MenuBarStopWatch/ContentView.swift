import SwiftUI

/// The main dropdown menu content view that appears when clicking the menu bar item.
/// Displays control buttons for the stopwatch.
struct ContentView: View {
    /// Environment object provided by the parent view that controls the stopwatch.
    @EnvironmentObject private var stopwatchController: StopwatchController

    var body: some View {
        VStack(spacing: 0) {
            // Stopwatch control buttons
            MenuButton(action: stopwatchController.startTimer, title: "Start", shortcut: "s")
            MenuButton(action: stopwatchController.stopTimer, title: "Stop", shortcut: "p")
            MenuButton(action: stopwatchController.resetTimer, title: "Reset", shortcut: "r")

            Divider()
                .padding(.vertical, 4)
            
            // Quit application button
            MenuButton(action: { NSApp.terminate(nil) }, title: "Quit", shortcut: "q")
                .foregroundColor(.red)
        }
        .padding(.vertical, 8)
        .frame(width: 180)
    }
}

/// A custom button styled for the menu dropdown with hover effects and keyboard shortcut display.
struct MenuButton: View {
    /// The action to perform when the button is clicked.
    let action: () -> Void
    /// The button text label.
    let title: String
    /// The keyboard shortcut character to display (without modifiers).
    let shortcut: String
    /// Tracks whether the mouse is hovering over this button.
    @State private var isHovered = false
    
    var body: some View {
        Button {
            // Execute the provided action and dismiss the menu
            action()
            NSApp.keyWindow?.orderOut(nil)
        } label: {
            HStack {
                Text(title)
                    .font(.body)
                    .foregroundColor(isHovered ? .white : .primary)
                Spacer()
                Text(shortcut.uppercased())
                    .font(.caption)
                    .foregroundColor(isHovered ? .white : .gray)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(isHovered ? Color(nsColor: .selectedContentBackgroundColor) : .clear)
            )
        }
        .buttonStyle(.plain)
        .frame(height: 24)
        .onHover { hovering in
            isHovered = hovering
        }
        .animation(.easeOut(duration: 0.05), value: isHovered)
    }
}

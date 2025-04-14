import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appDelegate: AppDelegate
    
    var body: some View {
        VStack(spacing: 0) {
            MenuButton(action: appDelegate.startTimer, title: "Start", shortcut: "s")
            MenuButton(action: appDelegate.stopTimer, title: "Stop", shortcut: "p")
            MenuButton(action: appDelegate.resetTimer, title: "Reset", shortcut: "r")
            
            Divider()
                .padding(.vertical, 4)
            
            MenuButton(action: appDelegate.quitTimer, title: "Quit", shortcut: "q")
                .foregroundColor(.red)
        }
        .padding(.vertical, 8)
        .frame(width: 180)
    }
}

struct MenuButton: View {
    let action: () -> Void
    let title: String
    let shortcut: String
    @State private var isHovered = false
    
    var body: some View {
        Button {
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

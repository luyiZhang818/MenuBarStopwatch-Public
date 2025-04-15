import AppIntents
import StopWatchKit

/// An App Intent for controlling the Stopwatch via system shortcuts.
/// This enables the app to be controlled via Shortcuts app or Siri.
struct StopwatchShortcut: AppIntent {
    static var title: LocalizedStringResource = "Control Stopwatch"
    
    /// The action parameter determines which operation to perform on the stopwatch.
    @Parameter(title: "Action", default: .start)
    var action: StopwatchAction
    
    /// Provides a natural language description of the intent for the Shortcuts app.
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$action) the stopwatch")
    }

    /// Performs the selected stopwatch action when the shortcut is triggered.
    func perform() async throws -> some IntentResult {
        switch action {
        case .start:
            StopwatchManager.shared.startTimer()
        case .stop:
            StopwatchManager.shared.stopTimer()
        case .reset:
            StopwatchManager.shared.resetTimer()
        }
        return .result()
    }
}

/// Enum representing the available actions that can be performed via shortcuts.
enum StopwatchAction: String, AppEnum {
    case start, stop, reset
    
    /// Display representation for the Shortcuts app UI.
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Stopwatch Action"
    
    /// Display names for each action in the Shortcuts app UI.
    static var caseDisplayRepresentations: [StopwatchAction: DisplayRepresentation] = [
        .start: "Start",
        .stop: "Stop",
        .reset: "Reset"
    ]
}

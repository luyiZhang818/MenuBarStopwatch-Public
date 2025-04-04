import AppIntents

struct StopwatchShortcut: AppIntent {
    static var title: LocalizedStringResource = "Control Stopwatch"
    
    @Parameter(title: "Action", default: .start)
    var action: StopwatchAction
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$action) the stopwatch")
    }

    func perform() async throws -> some IntentResult {

        let notificationName: String
        switch action {
        case .start:
            notificationName = "app.menubar.stopwatch.start"
        case .stop:
            notificationName = "app.menubar.stopwatch.stop"
        case .reset:
            notificationName = "app.menubar.stopwatch.reset"
        }
        
        DistributedNotificationCenter.default().post(
            name: Notification.Name(notificationName),
            object: nil,
        )
        
        return .result()
    }
}
enum StopwatchAction: String, AppEnum {
    case start
    case stop
    case reset
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Stopwatch Action"
    
    static var caseDisplayRepresentations: [StopwatchAction : DisplayRepresentation] = [
        .start: "Start",
        .stop: "Stop",
        .reset: "Reset"
    ]
}

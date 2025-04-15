import SwiftUI
import StopWatchKit

/// An ObservableObject for SwiftUI that bridges between the StopwatchManager and
/// the UI components. Publishes updated time strings for SwiftUI views to observe.
class StopwatchController: ObservableObject, StopwatchManagerDelegate {
    /// Published property that triggers UI updates when the time changes.
    @Published var currentTime: String = "00:00:00"
    
    /// Reference to the singleton stopwatch manager.
    private let stopwatchManager: StopwatchManager
    
    /// Initializes the controller and sets itself as the manager's delegate.
    init(manager: StopwatchManager = StopwatchManager.shared) {
        self.stopwatchManager = manager
        // Assign self as the manager delegate to receive time updates.
        stopwatchManager.delegate = self
    }
    
    // MARK: - StopwatchManagerDelegate
    
    /// Implementation of the StopwatchManagerDelegate protocol.
    /// Updates the published currentTime property when notified by the manager.
    func didUpdateTime(_ timeString: String) {
        // Ensure updates happen on the main thread
        DispatchQueue.main.async {
            self.currentTime = timeString
        }
    }
    
    // MARK: - Timer Control Methods
    
    /// Starts the stopwatch timer.
    func startTimer() {
        stopwatchManager.startTimer()
    }
    
    /// Stops (pauses) the stopwatch timer.
    func stopTimer() {
        stopwatchManager.stopTimer()
    }
    
    /// Resets the stopwatch timer to 00:00:00.
    func resetTimer() {
        stopwatchManager.resetTimer()
    }
}

import Foundation

/// Protocol for receiving updates from the StopwatchManager.
/// Implementers will receive time string updates when the stopwatch status changes.
public protocol StopwatchManagerDelegate: AnyObject {
    /// Called when the stopwatch time changes or is reset.
    /// - Parameter timeString: The current time in "HH:MM:SS" format.
    func didUpdateTime(_ timeString: String)
}

/// Manages the stopwatch functionality, including starting, stopping, and resetting the timer.
/// Uses a singleton pattern to ensure consistent state across the app.
public class StopwatchManager {
    /// Shared instance to access the StopwatchManager.
    public static let shared = StopwatchManager()
    
    /// UserDefaults container for persisting timer state across app restarts.
    private let userDefaults = UserDefaults(suiteName: "group.io.luyi.MenuBarStopWatch")
    
    /// Delegate to receive updates when the timer value changes.
    public weak var delegate: StopwatchManagerDelegate?
    
    /// Timer object used to trigger periodic updates.
    private var timer: Timer?
    
    /// The time when the stopwatch started, persisted in UserDefaults.
    private var startTime: Date? {
        get {
            userDefaults?.object(forKey: "startTime") as? Date
        }
        set {
            userDefaults?.set(newValue, forKey: "startTime")
        }
    }
    
    /// Whether the stopwatch is currently running.
    private(set) public var isRunning = false
    
    /// The current time as a formatted string (read-only).
    public private(set) var currentTime: String?
    
    /// Private initializer to enforce singleton pattern.
    private init() {}
    
    /// Starts the stopwatch timer.
    /// If the timer was previously paused, it will continue from where it left off.
    public func startTimer() {
        if startTime == nil {
            // First start - initialize startTime
            startTime = Date()
        } else {
            // Resume from pause - adjust startTime to maintain elapsed time
            let elapsed = -startTime!.timeIntervalSinceNow
            startTime = Date().addingTimeInterval(-elapsed)
        }
        
        // Clean up any existing timer
        timer?.invalidate()
        
        // Create a new timer on the main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
                self?.updateDisplay()
            }
            RunLoop.main.add(self.timer!, forMode: .common)
        }
        
        isRunning = true
        // Force an immediate update to ensure UI reflects the change
        updateDisplay()
    }
    
    /// Stops (pauses) the stopwatch timer.
    /// The elapsed time is preserved so the timer can be resumed.
    public func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    /// Resets the stopwatch to 00:00:00.
    /// Stops the timer and clears the start time.
    public func resetTimer() {
        stopTimer()
        startTime = nil
        delegate?.didUpdateTime("00:00:00")
    }
    
    /// Quits the timer and resets the display.
    /// This method is functionally identical to resetTimer and could be consolidated.
    public func quitTimer() {
        stopTimer()
        startTime = nil
        delegate?.didUpdateTime("00:00:00")
    }

    /// Updates the display with the current elapsed time.
    /// Called periodically by the timer and immediately after state changes.
    private func updateDisplay() {
        guard let startTime = startTime else { return }
        
        let elapsed = Date().timeIntervalSince(startTime)
        let hours = Int(elapsed) / 3600
        let minutes = (Int(elapsed) % 3600) / 60
        let seconds = Int(elapsed) % 60
        
        let timeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        // Ensure UI updates happen on the main thread
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didUpdateTime(timeString)
        }
    }
}

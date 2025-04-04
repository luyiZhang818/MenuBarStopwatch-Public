import Foundation

public protocol StopwatchManagerDelegate: AnyObject {
    func didUpdateTime(_ timeString: String)
}

public class StopwatchManager {
    public static let shared = StopwatchManager()
    
    private let userDefaults = UserDefaults(suiteName: "group.example.MenuBarStopWatch")
    
    public weak var delegate: StopwatchManagerDelegate?
    private var timer: Timer?
    private var startTime: Date? {
        get {
            userDefaults?.object(forKey: "startTime") as? Date
        }
        set {
            userDefaults?.set(newValue, forKey: "startTime")
        }
    }
    private(set) public var isRunning = false
    public private(set) var currentTime: String?
    
    private init() {}
    
    public func startTimer() {
        if startTime == nil {
            startTime = Date()
        } else {
            let elapsed = -startTime!.timeIntervalSinceNow
            startTime = Date().addingTimeInterval(-elapsed)
        }
        
        timer?.invalidate() // Invalidate any existing timer
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
                self?.updateDisplay()
            }
            RunLoop.main.add(self.timer!, forMode: .common)
        }
        
        isRunning = true
    }
    
    public func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    public func resetTimer() {
        stopTimer()
        startTime = nil
        delegate?.didUpdateTime("00:00:00")
    }
    
    public func quitTimer() {
        stopTimer()
        startTime = nil
        delegate?.didUpdateTime("00:00:00")
    }

    private func updateDisplay() {
        guard let startTime = startTime else { return }
        
        let elapsed = Date().timeIntervalSince(startTime)
        let hours = Int(elapsed) / 3600
        let minutes = (Int(elapsed) % 3600) / 60
        let seconds = Int(elapsed) % 60
        
        let timeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        DispatchQueue.main.async {
            self.delegate?.didUpdateTime(timeString)
        }
    }
}

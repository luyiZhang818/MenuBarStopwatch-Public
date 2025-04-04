import SwiftUI
import StopWatchKit

class AppDelegate: NSObject, NSApplicationDelegate, StopwatchManagerDelegate, ObservableObject {
    @Published var currentTime: String = "00:00:00"
    
    let stopwatchManager = StopwatchManager.shared
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        stopwatchManager.delegate = self
        
        let notificationCenter = DistributedNotificationCenter.default()
        
        notificationCenter.addObserver(self, selector: #selector(handleStart), name: Notification.Name("com.zly.MenuBarStopWatch.start"), object: nil, suspensionBehavior: .deliverImmediately)
        notificationCenter.addObserver(self, selector: #selector(handleStop), name: Notification.Name("com.zly.MenuBarStopWatch.stop"), object: nil, suspensionBehavior: .deliverImmediately)
        notificationCenter.addObserver(self, selector: #selector(handleReset), name: Notification.Name("com.zly.MenuBarStopWatch.reset"), object: nil, suspensionBehavior: .deliverImmediately)
        
        NSApp.appearance = NSAppearance(named: .darkAqua) // Force test dark mode
    }
    
    @objc private func handleStart() {
        print("Received start notification")
        startTimer()
    }

    @objc private func handleStop() {
        print("Received stop notification")
        stopTimer()
    }

    @objc private func handleReset() {
        print("Received reset notification")
        resetTimer()
    }
    
    func didUpdateTime(_ timeString: String) {
        currentTime = timeString
    }
    
    func startTimer() { stopwatchManager.startTimer() }
    func stopTimer() { stopwatchManager.stopTimer() }
    func resetTimer() { stopwatchManager.resetTimer() }
}

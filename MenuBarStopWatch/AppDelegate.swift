import SwiftUI
import StopWatchKit

class AppDelegate: NSObject, NSApplicationDelegate, StopwatchManagerDelegate, ObservableObject {
    @Published var currentTime: String = "00:00:00"
    
    let stopwatchManager = StopwatchManager.shared
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        stopwatchManager.delegate = self
        
        let notificationCenter = DistributedNotificationCenter.default()
        
        notificationCenter.addObserver(self, selector: #selector(handleStart), name: Notification.Name("app.menubar.stopwatch.start"), object: nil, suspensionBehavior: .deliverImmediately)
        notificationCenter.addObserver(self, selector: #selector(handleStop), name: Notification.Name("app.menubar.stopwatch.stop"), object: nil, suspensionBehavior: .deliverImmediately)
        notificationCenter.addObserver(self, selector: #selector(handleReset), name: Notification.Name("app.menubar.stopwatch.reset"), object: nil, suspensionBehavior: .deliverImmediately)
        notificationCenter.addObserver(self, selector: #selector(handleQuit), name: Notification.Name("app.menubar.stopwatch.quit"), object: nil, suspensionBehavior: .deliverImmediately)
        
    }
    
    
    
    @objc private func handleStart() {
        startTimer()
    }

    @objc private func handleStop() {
        stopTimer()
    }

    @objc private func handleReset() {
        resetTimer()
    }
    
    @objc private func handleQuit() {
        resetTimer()
        NSApp.terminate(nil)
    }

    func didUpdateTime(_ timeString: String) {
        currentTime = timeString
    }
    
    func startTimer() { stopwatchManager.startTimer() }
    func stopTimer() { stopwatchManager.stopTimer() }
    func resetTimer() { stopwatchManager.resetTimer() }
    func quitTimer() { stopwatchManager.quitTimer()
        NSApp.terminate(nil)}

}

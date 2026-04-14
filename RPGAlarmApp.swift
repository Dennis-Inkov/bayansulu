import SwiftUI

@main
struct RPGAlarmApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var alarmVM = AlarmViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(alarmVM)
        }
    }
}

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Called when notification arrives while app is in FOREGROUND
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        fireAlarm(from: notification.request.content.userInfo)
        completionHandler([.banner])
    }

    // Called when user taps notification from BACKGROUND or locked screen
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        fireAlarm(from: response.notification.request.content.userInfo)
        completionHandler()
    }

    private func fireAlarm(from userInfo: [AnyHashable: Any]) {
        AudioService.shared.startAlarm()
        NotificationCenter.default.post(
            name: .alarmDidFire,
            object: nil,
            userInfo: userInfo
        )
    }
}

extension Notification.Name {
    static let alarmDidFire = Notification.Name("rpg_alarmDidFire")
}

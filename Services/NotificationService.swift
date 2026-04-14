import UserNotifications
import Foundation

final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    func requestPermission() async throws -> Bool {
        try await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
    }

    func scheduleAlarm(_ alarm: AlarmModel) throws {
        let content = UNMutableNotificationContent()
        content.title = "🎮 RPG Alarm"
        content.body = alarm.label.isEmpty ? "Пора вставать! Пройди игры, чтобы выключить будильник." : alarm.label
        content.sound = UNNotificationSound(named: UNNotificationSoundName("alarm.caf"))
        content.userInfo = ["alarmId": alarm.id.uuidString]
        content.categoryIdentifier = "ALARM_CATEGORY"

        var components = Calendar.current.dateComponents([.hour, .minute], from: alarm.time)
        components.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: alarm.id.uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    func cancelAlarm(id: UUID) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
}

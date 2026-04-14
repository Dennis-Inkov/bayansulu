import Foundation

@MainActor
final class AlarmViewModel: ObservableObject {
    @Published var alarms: [AlarmModel] = []

    private let storageKey = "rpg_alarms"

    init() {
        load()
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([AlarmModel].self, from: data) else { return }
        alarms = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(alarms) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    func addAlarm(_ alarm: AlarmModel) {
        alarms.append(alarm)
        save()
        if alarm.isEnabled {
            try? NotificationService.shared.scheduleAlarm(alarm)
        }
    }

    func toggleAlarm(_ alarm: AlarmModel) {
        guard let idx = alarms.firstIndex(where: { $0.id == alarm.id }) else { return }
        alarms[idx].isEnabled.toggle()
        save()
        if alarms[idx].isEnabled {
            try? NotificationService.shared.scheduleAlarm(alarms[idx])
        } else {
            NotificationService.shared.cancelAlarm(id: alarm.id)
        }
    }

    func deleteAlarms(at offsets: IndexSet) {
        for idx in offsets {
            NotificationService.shared.cancelAlarm(id: alarms[idx].id)
        }
        alarms.remove(atOffsets: offsets)
        save()
    }
}

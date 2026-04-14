import Foundation

struct AlarmModel: Identifiable, Codable {
    var id: UUID = UUID()
    var time: Date
    var label: String
    var isEnabled: Bool = true
}

import SwiftUI

struct AlarmEditView: View {
    @EnvironmentObject var alarmVM: AlarmViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var time: Date = Date()
    @State private var label: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.rpgBackgroundStart, .rpgBackgroundEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    DatePicker("Время будильника", selection: $time, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .colorScheme(.dark)

                    TextField("Название (необязательно)", text: $label)
                        .padding()
                        .background(Color.rpgCard)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .foregroundColor(.white)
                        .colorScheme(.dark)

                    Button("Сохранить") {
                        let alarm = AlarmModel(time: time, label: label)
                        alarmVM.addAlarm(alarm)
                        dismiss()
                    }
                    .buttonStyle(RPGButtonStyle())
                }
                .padding(24)
            }
            .navigationTitle("Новый будильник")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                        .foregroundColor(.rpgPurpleEnd)
                }
            }
        }
        .colorScheme(.dark)
    }
}

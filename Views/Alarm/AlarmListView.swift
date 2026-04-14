import SwiftUI

struct AlarmListView: View {
    @EnvironmentObject var alarmVM: AlarmViewModel
    @State private var showingAddAlarm = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.rpgBackgroundStart, .rpgBackgroundEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Group {
                    if alarmVM.alarms.isEmpty {
                        VStack(spacing: 16) {
                            Text("🎮")
                                .font(.system(size: 64))
                            Text("Нет будильников")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.6))
                            Text("Нажми + чтобы добавить")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.4))
                        }
                    } else {
                        List {
                            ForEach(alarmVM.alarms) { alarm in
                                AlarmRowView(alarm: alarm)
                                    .listRowBackground(Color.rpgCard)
                                    .listRowSeparatorTint(.white.opacity(0.1))
                            }
                            .onDelete(perform: alarmVM.deleteAlarms)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("🎮 RPG Alarm")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddAlarm = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.rpgPurpleEnd)
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingAddAlarm) {
                AlarmEditView()
                    .environmentObject(alarmVM)
            }
        }
        .colorScheme(.dark)
        .task {
            _ = try? await NotificationService.shared.requestPermission()
        }
    }
}

struct AlarmRowView: View {
    @EnvironmentObject var alarmVM: AlarmViewModel
    let alarm: AlarmModel

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: alarm.time)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(timeString)
                    .font(.system(size: 36, weight: .light, design: .rounded))
                    .foregroundColor(alarm.isEnabled ? .white : .white.opacity(0.4))
                if !alarm.label.isEmpty {
                    Text(alarm.label)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            Spacer()
            Toggle("", isOn: Binding(
                get: { alarm.isEnabled },
                set: { _ in alarmVM.toggleAlarm(alarm) }
            ))
            .tint(.rpgPurpleEnd)
        }
        .padding(.vertical, 8)
    }
}

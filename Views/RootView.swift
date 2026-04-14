import SwiftUI

struct RootView: View {
    @EnvironmentObject var alarmVM: AlarmViewModel
    @StateObject private var gameVM = GameViewModel()
    @State private var isAlarmActive = false

    var body: some View {
        ZStack {
            if isAlarmActive {
                ActiveGameView()
                    .environmentObject(gameVM)
                    .transition(.opacity)
                    .zIndex(1)
            } else {
                AlarmListView()
                    .environmentObject(alarmVM)
                    .transition(.opacity)
                    .zIndex(0)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isAlarmActive)
        .onReceive(NotificationCenter.default.publisher(for: .alarmDidFire)) { _ in
            gameVM.startGame()
            isAlarmActive = true
        }
        .onChange(of: gameVM.isDismissed) { dismissed in
            if dismissed {
                isAlarmActive = false
            }
        }
    }
}

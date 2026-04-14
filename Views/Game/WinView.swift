import SwiftUI
import ConfettiSwiftUI

struct WinView: View {
    @EnvironmentObject var gameVM: GameViewModel

    var body: some View {
        ZStack {
            RPGCardView {
                VStack(spacing: 20) {
                    Text("🎉 Поздравляем!")
                        .font(.largeTitle).bold()
                        .foregroundColor(.white)

                    Text("Ты прошёл все уровни!")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.85))

                    Text("🔕 Будильник успешно выключен")
                        .font(.headline)
                        .foregroundColor(.rpgGreen)
                        .multilineTextAlignment(.center)

                    Button("Начать заново") {
                        gameVM.restart()
                    }
                    .buttonStyle(RPGButtonStyle())
                    .padding(.top, 8)
                }
            }
            .padding(.horizontal, 24)

            ConfettiCannon(
                counter: $gameVM.confettiTrigger,
                num: 150,
                colors: [.purple, .green, .blue, .pink, .yellow, .orange],
                radius: 400
            )
        }
    }
}

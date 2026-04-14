import SwiftUI

struct MathGameView: View {
    @EnvironmentObject var gameVM: GameViewModel

    var body: some View {
        RPGCardView {
            VStack(spacing: 24) {
                Text("🧠 Уровень 1: Реши пример")
                    .font(.title2).bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("\(gameVM.currentQuestion.a) + \(gameVM.currentQuestion.b) = ?")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                if gameVM.mathFeedback == .wrong {
                    Text("Неправильно! Попробуй снова")
                        .foregroundColor(.rpgRed)
                        .font(.subheadline)
                        .transition(.opacity)
                }

                HStack(spacing: 12) {
                    ForEach(gameVM.currentQuestion.shuffledAnswers, id: \.self) { answer in
                        Button("\(answer)") {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            gameVM.answerMath(answer)
                        }
                        .buttonStyle(RPGButtonStyle())
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

import SwiftUI

struct MemoryGameView: View {
    @EnvironmentObject var gameVM: GameViewModel

    var body: some View {
        RPGCardView {
            VStack(spacing: 24) {
                Text("🧠 Уровень 3: Запомни и повтори")
                    .font(.title2).bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                if gameVM.showSequence {
                    VStack(spacing: 8) {
                        Text("Запомни последовательность:")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.subheadline)

                        Text(gameVM.sequence.joined(separator: " - "))
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .transition(.opacity)
                    }
                } else {
                    VStack(spacing: 8) {
                        Text("Повтори последовательность:")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.subheadline)

                        Text(gameVM.userInput.joined(separator: " - "))
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.rpgPurpleEnd)
                            .frame(minHeight: 50)

                        if gameVM.memoryFeedback == .wrong {
                            Text("Неправильно! Смотри снова")
                                .foregroundColor(.rpgRed)
                                .font(.subheadline)
                                .transition(.opacity)
                        }

                        HStack(spacing: 16) {
                            ForEach(["A", "B", "C"], id: \.self) { letter in
                                Button(letter) {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    gameVM.tapMemoryButton(letter)
                                }
                                .buttonStyle(RPGButtonStyle())
                            }
                        }
                        .padding(.top, 8)
                        .disabled(gameVM.memoryFeedback == .wrong)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .animation(.easeInOut(duration: 0.3), value: gameVM.showSequence)
    }
}

import SwiftUI

struct TimingGameView: View {
    @EnvironmentObject var gameVM: GameViewModel

    var body: some View {
        RPGCardView {
            VStack(spacing: 28) {
                Text("⚡ Уровень 2: Нажми в нужный момент")
                    .font(.title2).bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("Нажми кнопку, когда красный шарик попадёт в зелёную зону")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)

                // Timing bar — scaled to available width while preserving 300pt logic
                GeometryReader { geo in
                    let scale = geo.size.width / 300
                    let barH: CGFloat = 20
                    let ballSize: CGFloat = 20 * scale

                    ZStack(alignment: .leading) {
                        // Track
                        Capsule()
                            .fill(Color.rpgBarTrack)
                            .frame(height: barH)

                        // Green target zone (120-180 on 300pt scale)
                        RoundedRectangle(cornerRadius: barH / 2)
                            .fill(Color.rpgGreen)
                            .frame(width: 60 * scale, height: barH)
                            .offset(x: 120 * scale)

                        // Moving ball
                        Circle()
                            .fill(Color.rpgRed)
                            .frame(width: ballSize, height: ballSize)
                            .offset(x: gameVM.ballPosition * scale)
                    }
                }
                .frame(height: 20)

                feedbackLabel

                Button("НАЖАТЬ!") {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    gameVM.tapTimingButton()
                }
                .buttonStyle(RPGButtonStyle())
                .disabled(gameVM.timingFeedback != .none)
            }
        }
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var feedbackLabel: some View {
        switch gameVM.timingFeedback {
        case .hit:
            Text("Отлично! В цель!")
                .foregroundColor(.rpgGreen)
                .font(.subheadline.bold())
                .transition(.opacity)
        case .miss:
            Text("Мимо! Попробуй снова")
                .foregroundColor(.rpgRed)
                .font(.subheadline)
                .transition(.opacity)
        case .none:
            Text(" ")
                .font(.subheadline)
        }
    }
}

import SwiftUI

struct ActiveGameView: View {
    @EnvironmentObject var gameVM: GameViewModel

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.rpgBackgroundStart, .rpgBackgroundEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("🎮 RPG Alarm")
                    .font(.title2).bold()
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .padding(.bottom, 16)

                Spacer()

                Group {
                    switch gameVM.phase {
                    case .math:
                        MathGameView()
                            .transition(phaseTransition)
                    case .timing:
                        TimingGameView()
                            .transition(phaseTransition)
                    case .memory:
                        MemoryGameView()
                            .transition(phaseTransition)
                    case .win:
                        WinView()
                            .transition(phaseTransition)
                    }
                }
                .animation(.easeOut(duration: 0.4), value: gameVM.phase)

                Spacer()
            }
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    private var phaseTransition: AnyTransition {
        .asymmetric(
            insertion: .opacity.combined(with: .offset(y: 15)),
            removal: .opacity
        )
    }
}

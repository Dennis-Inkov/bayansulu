import Foundation
import UIKit

@MainActor
final class GameViewModel: ObservableObject {

    // MARK: - Phase
    @Published var phase: GamePhase = .math
    @Published var isDismissed: Bool = false

    // MARK: - Math
    @Published var currentQuestion: MathQuestion = .random()
    @Published var mathFeedback: MathFeedback = .none

    // MARK: - Timing
    @Published var ballPosition: CGFloat = 0
    @Published var timingFeedback: TimingFeedback = .none
    private var ballDirection: CGFloat = 1
    private var timingTimer: Timer?

    // MARK: - Memory
    @Published var sequence: [String] = []
    @Published var userInput: [String] = []
    @Published var showSequence: Bool = true
    @Published var memoryFeedback: MemoryFeedback = .none

    // MARK: - Confetti
    @Published var confettiTrigger: Int = 0

    // MARK: - Feedback enums
    enum MathFeedback { case none, wrong }
    enum TimingFeedback { case none, hit, miss }
    enum MemoryFeedback { case none, wrong }

    // MARK: - Game lifecycle

    func startGame() {
        isDismissed = false
        phase = .math
        currentQuestion = .random()
        mathFeedback = .none
    }

    func restart() {
        AudioService.shared.stopAlarm()
        timingTimer?.invalidate()
        timingTimer = nil
        isDismissed = true
    }

    // MARK: - Math game

    func answerMath(_ answer: Int) {
        if answer == currentQuestion.correctAnswer {
            mathFeedback = .none
            startTimingGame()
        } else {
            mathFeedback = .wrong
            Task {
                try? await Task.sleep(nanoseconds: 800_000_000)
                mathFeedback = .none
                currentQuestion = .random()
            }
        }
    }

    // MARK: - Timing game

    private func startTimingGame() {
        ballPosition = 0
        ballDirection = 1
        timingFeedback = .none
        phase = .timing

        timingTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.updateBall()
            }
        }
    }

    private func updateBall() {
        ballPosition += ballDirection * 2
        if ballPosition >= 280 {
            ballPosition = 280
            ballDirection = -1
        } else if ballPosition <= 0 {
            ballPosition = 0
            ballDirection = 1
        }
    }

    func tapTimingButton() {
        timingTimer?.invalidate()
        timingTimer = nil

        if ballPosition >= 120 && ballPosition <= 180 {
            timingFeedback = .hit
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000)
                timingFeedback = .none
                startMemoryGame()
            }
        } else {
            timingFeedback = .miss
            Task {
                try? await Task.sleep(nanoseconds: 800_000_000)
                timingFeedback = .none
                startTimingGame()
            }
        }
    }

    // MARK: - Memory game

    private func startMemoryGame() {
        let letters = ["A", "B", "C"]
        sequence = (0..<3).map { _ in letters.randomElement()! }
        userInput = []
        showSequence = true
        memoryFeedback = .none
        phase = .memory

        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            showSequence = false
        }
    }

    func tapMemoryButton(_ letter: String) {
        guard !showSequence else { return }
        userInput.append(letter)

        let idx = userInput.count - 1
        if userInput[idx] != sequence[idx] {
            memoryFeedback = .wrong
            Task {
                try? await Task.sleep(nanoseconds: 800_000_000)
                memoryFeedback = .none
                startMemoryGame()
            }
            return
        }

        if userInput.count == sequence.count {
            showWin()
        }
    }

    // MARK: - Win

    private func showWin() {
        phase = .win
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            confettiTrigger += 1
        }
    }
}

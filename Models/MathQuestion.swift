import Foundation

struct MathQuestion {
    let a: Int
    let b: Int

    var correctAnswer: Int { a + b }

    var shuffledAnswers: [Int] {
        [correctAnswer, correctAnswer + 1, correctAnswer - 1].shuffled()
    }

    static func random() -> MathQuestion {
        MathQuestion(a: Int.random(in: 0...9), b: Int.random(in: 0...9))
    }
}

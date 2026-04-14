import AVFoundation

final class AudioService {
    static let shared = AudioService()
    private var player: AVAudioPlayer?

    private init() {}

    func startAlarm() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                options: [.mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AudioService: session setup failed — \(error)")
        }

        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "caf") else {
            print("AudioService: alarm.caf not found in bundle")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
        } catch {
            print("AudioService: failed to create player — \(error)")
        }
    }

    func stopAlarm() {
        player?.stop()
        player = nil
        try? AVAudioSession.sharedInstance().setActive(
            false,
            options: .notifyOthersOnDeactivation
        )
    }
}

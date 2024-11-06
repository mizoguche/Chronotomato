//
//  TimerViewModel.swift
//  Chronotomato
//
//  Created by Michiaki Mizoguchi on 2024/11/03.
//

import Foundation
import AVFoundation

enum ViewStatus {
    case timer
    case error
}

@MainActor
final class TimerViewModel: ObservableObject {
    @Published var timerStatus: TimerStatus = .stopped(currentPresetIndex: 0)
    @Published var viewStatus: ViewStatus = .timer

    var timer: Timer?
    var audioPlayer: AVAudioPlayer?

    func play() {
        do {
            let nextStatus = try timerStatus.play()
            timerStatus = nextStatus
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                Task {
                    await self.tick()
                }
            }
        } catch {
            viewStatus = .error
        }
    }

    func tick() {
        do {
            let nextStatus = try timerStatus.tick()
            timerStatus = nextStatus
            switch timerStatus {
            case .stopped:
                stop()
            case .alarming:
                alarm()
            case .playing:
                break
            }
        } catch {
            viewStatus = .error
        }
    }

    private func alarm() {
        timer?.invalidate()

        playAlarm()
    }

    private func playAlarm() {
        if audioPlayer == nil,
           let audioPath = Bundle.main.path(forResource: "Alarm", ofType: "mp3") {
            let audioUrl = URL(fileURLWithPath: audioPath)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
                audioPlayer?.numberOfLoops = -1 // Infinite loop
            } catch {
                viewStatus = .error
            }
        }
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }

    func stop() {
        timer?.invalidate()
        audioPlayer?.stop()

        do {
            let nextStatus = try timerStatus.stop()
            timerStatus = nextStatus
        } catch {
            viewStatus = .error
        }
    }
}

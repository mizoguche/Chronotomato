import Foundation

enum TimerError: Error {
    case illegalStatusTransition
}

let long = 25 * 60
let short = 5 * 60
let presets: [Int] = [long, short]

func formatTime(_ time: Int) -> String {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits = [.minute, .second]
    return formatter.string(from: TimeInterval(time)) ?? "Error"
}

enum TimerStatus: Equatable {
    case playing(currentPresetIndex: Int, remainingTime: Int)
    case alarming(currentPresetIndex: Int)
    case stopped(currentPresetIndex: Int)

    var remainingTime: String {
        switch self {
        case .playing(_, let remainingTime):
            return formatTime(remainingTime)
        case .alarming, .stopped:
            return formatTime(0)
        }
    }

    func play() throws(TimerError) -> TimerStatus {
        switch self {
        case .playing:
            return self
        case .alarming:
            throw TimerError.illegalStatusTransition
        case .stopped(let currentPresetIndex):
            let nextInterval = presets[currentPresetIndex]
            return .playing(currentPresetIndex: currentPresetIndex, remainingTime: nextInterval)
        }
    }

    func stop() throws(TimerError) -> TimerStatus {
        switch self {
        case .playing(let currentPresetIndex, _):
            return .stopped(currentPresetIndex: currentPresetIndex)
        case .alarming(let currentPresetIndex):
            let nextPresetIndex = (currentPresetIndex + 1) % presets.count
            return .stopped(currentPresetIndex: nextPresetIndex)
        case .stopped:
            throw TimerError.illegalStatusTransition
        }
    }

    func alarm() throws(TimerError) -> TimerStatus {
        switch self {
        case .playing(let currentPresetIndex, _):
            return .alarming(currentPresetIndex: currentPresetIndex)
        case .alarming, .stopped:
            throw TimerError.illegalStatusTransition
        }
    }

    func tick() throws(TimerError) -> TimerStatus {
        switch self {
        case .playing(let currentPresetIndex, let remainingTime):
            let remainingTime = remainingTime - 1
            if remainingTime > 0 {
                return .playing(currentPresetIndex: currentPresetIndex, remainingTime: remainingTime)
            } else {
                return .alarming(currentPresetIndex: currentPresetIndex)
            }
        case .alarming, .stopped:
            throw TimerError.illegalStatusTransition
        }
    }
}

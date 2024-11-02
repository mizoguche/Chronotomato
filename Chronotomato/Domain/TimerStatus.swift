import Foundation

enum TimerStatus {
    case playing(presetTime: Int, remainingTime: Int)
    case alarming
    case stopped(presetTime: Int)

    func toNextStatus() -> TimerStatus {
        switch self {
        case .playing(let presetTime, let remainingTime):
            let remainingTime = remainingTime - 1
            if remainingTime > 0 {
                return .playing(presetTime: presetTime, remainingTime: remainingTime)
            } else {
                return .alarming
            }
        case .alarming:
            return .stopped(presetTime: 0)
        case .stopped(let presetTime):
            return .playing(presetTime: presetTime, remainingTime: presetTime)
        }
    }
}

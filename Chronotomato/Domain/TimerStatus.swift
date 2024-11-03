import Foundation

enum TimerStatus {
    case playing(presetTime: Int, remainingTime: Int)
    case alarming
    case stopped(presetTime: Int)

    var remainingTime: String {
        switch self {
        case .playing(_, let remainingTime):
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            formatter.allowedUnits = [.minute, .second]

            let interval = TimeInterval(remainingTime)
            return formatter.string(from: interval) ?? "Error"
        case .alarming:
            return "00:00"
        case .stopped:
            return "00:00"
        }
    }

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

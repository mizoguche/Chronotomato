@testable import Chronotomato
import XCTest

final class TimerStatusTests: XCTestCase {
    func testPlayingToPlaying() {
        let initialStatus = TimerStatus.playing(presetTime: 300, remainingTime: 120)
        let nextStatus = initialStatus.toNextStatus()

        if case .playing(let presetTime, let remainingTime) = nextStatus {
            XCTAssertEqual(presetTime, 300)
            XCTAssertEqual(remainingTime, 119)
        } else {
            XCTFail("Expected playing Status")
        }
    }

    func testPlayingToAlarming() {
        let initialStatus = TimerStatus.playing(presetTime: 300, remainingTime: 1)
        let nextStatus = initialStatus.toNextStatus()

        if case .alarming = nextStatus {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected alarming Status. nextStatus: \(nextStatus)")
        }
    }

    func testAlarmingToStopped() {
        let initialStatus = TimerStatus.alarming
        let nextStatus = initialStatus.toNextStatus()

        if case .stopped(let presetTime) = nextStatus {
            XCTAssertEqual(presetTime, 0)
        } else {
            XCTFail("Expected stopped Status")
        }
    }

    func testStoppedToPlaying() {
        let initialStatus = TimerStatus.stopped(presetTime: 300)
        let nextStatus = initialStatus.toNextStatus()

        if case .playing(let presetTime, let remainingTime) = nextStatus {
            XCTAssertEqual(presetTime, 300)
            XCTAssertEqual(remainingTime, 300)
        } else {
            XCTFail("Expected playing Status")
        }
    }

    func testRemainingTime() {
        let playingStatusSeconds = TimerStatus.playing(presetTime: 300, remainingTime: 59 * 1)
        XCTAssertEqual(playingStatusSeconds.remainingTime, "00:59")

        let playingStatusMinutes = TimerStatus.playing(presetTime: 300, remainingTime: 60 * 1)
        XCTAssertEqual(playingStatusMinutes.remainingTime, "01:00")

        let playingStatusHour = TimerStatus.playing(presetTime: 300, remainingTime: 60 * 60)
        XCTAssertEqual(playingStatusHour.remainingTime, "60:00")

        let alarmingStatus = TimerStatus.alarming
        XCTAssertEqual(alarmingStatus.remainingTime, "00:00")

        let stoppedStatus = TimerStatus.stopped(presetTime: 300)
        XCTAssertEqual(stoppedStatus.remainingTime, "00:00")
    }
}

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
}

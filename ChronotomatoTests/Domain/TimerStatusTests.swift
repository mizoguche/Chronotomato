@testable import Chronotomato
import XCTest

final class TimerStatusTests: XCTestCase {
    func testFormatTime() {
        XCTAssertEqual(formatTime(59 * 1), "00:59")
        XCTAssertEqual(formatTime(60 * 1), "01:00")
        XCTAssertEqual(formatTime(60 * 60), "60:00")
        XCTAssertEqual(formatTime(0), "00:00")
    }

    // MARK: - TimerStatus.play
    func testPlayOnStopped() {
        let status = TimerStatus.stopped(currentPresetIndex: 0)
        let nextStatus = try! status.play()
        XCTAssertEqual(nextStatus, TimerStatus.playing(currentPresetIndex: 0, remainingTime: presets[0]))
    }

    func testPlayOnPlaying() {
        let status = TimerStatus.playing(currentPresetIndex: 0, remainingTime: 10)
        let nextStatus = try! status.play()
        XCTAssertEqual(nextStatus, status)
    }

    func testPlayOnAlarming() {
        let status = TimerStatus.alarming(currentPresetIndex: 0)
        XCTAssertThrowsError(try status.play())
    }

    // MARK: - TimerStatus.stop
    func testStopOnStopped() {
        let status = TimerStatus.stopped(currentPresetIndex: 0)
        XCTAssertThrowsError(try status.stop())
    }

    func testStopOnPlaying() {
        let status = TimerStatus.playing(currentPresetIndex: 0, remainingTime: 10)
        let nextStatus = try! status.stop()
        XCTAssertEqual(nextStatus, TimerStatus.stopped(currentPresetIndex: 0))
    }

    func testStopOnAlarming() {
        let status = TimerStatus.alarming(currentPresetIndex: 0)
        let nextStatus = try! status.stop()
        XCTAssertEqual(nextStatus, TimerStatus.stopped(currentPresetIndex: 1))
    }

    // MARK: - TimerStatus.alarm
    func testAlarmOnStopped() {
        let status = TimerStatus.stopped(currentPresetIndex: 0)
        XCTAssertThrowsError(try status.alarm())
    }

    func testAlarmOnPlaying() {
        let status = TimerStatus.playing(currentPresetIndex: 0, remainingTime: 10)
        let nextStatus = try! status.alarm()
        XCTAssertEqual(nextStatus, TimerStatus.alarming(currentPresetIndex: 0))
    }

    func testAlarmOnAlarming() {
        let status = TimerStatus.alarming(currentPresetIndex: 0)
        XCTAssertThrowsError(try status.alarm())
    }

    // MARK: - TimerStatus.tick
    func testTickOnPlaying() {
        let status = TimerStatus.playing(currentPresetIndex: 0, remainingTime: 10)
        let nextStatus = try! status.tick()
        XCTAssertEqual(nextStatus, TimerStatus.playing(currentPresetIndex: 0, remainingTime: 9))
    }

    func testTickOnStopped() {
        let status = TimerStatus.stopped(currentPresetIndex: 0)
        XCTAssertThrowsError(try status.tick())
    }

    func testTickOnAlarming() {
        let status = TimerStatus.alarming(currentPresetIndex: 0)
        XCTAssertThrowsError(try status.tick())
    }
}

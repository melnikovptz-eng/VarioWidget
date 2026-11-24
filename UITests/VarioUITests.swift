import XCTest

final class VarioUITests: XCTestCase {
    func testMainScreenRendersTelemetry() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["VARIO"].firstMatch.waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["LIVE"].exists)
        XCTAssertTrue(app.staticTexts["+2.4"].exists)
        XCTAssertTrue(app.staticTexts["CLIMB"].exists)

        XCTAssertTrue(app.staticTexts["ALT"].exists)
        XCTAssertTrue(app.staticTexts["245"].exists)
        XCTAssertTrue(app.staticTexts["PRESS"].exists)
        XCTAssertTrue(app.staticTexts["1013.2"].exists)
        XCTAssertTrue(app.staticTexts["TEMP"].exists)
        XCTAssertTrue(app.staticTexts["22.5"].exists)

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "VARIO-main-screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

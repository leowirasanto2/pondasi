//
//  JournalAppUITestsLaunchTests.swift
//  JournalAppUITests
//
//  Created by Leo Wirasanto Laia on 02/04/26.
//

// MARK: - DISABLED
// UI tests are temporarily disabled to keep the local test loop fast.
// See JournalAppUITests.swift for context. Re-enable by deleting the
// `#if false` line below and the matching `#endif` at the bottom.

#if false
import XCTest

final class JournalAppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
#endif

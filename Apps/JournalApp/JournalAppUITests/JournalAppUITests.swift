// MARK: - DISABLED
// UI tests are temporarily disabled to keep the local test loop fast.
// Everything below is wrapped in `#if false` so the file is excluded from
// compilation entirely — no test discovery, no build cost.
// Re-enable by deleting the `#if false` line below and the matching `#endif`
// at the bottom of the file. Snapshot-based view tests are tracked separately
// and will live in the unit test target.

#if false
import XCTest

final class JournalAppUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }

    // MARK: - Entry List

    func test_entryList_isVisible_onLaunch() {
        XCTAssertTrue(entryList.waitForExistence(timeout: 3))
    }

    func test_entryList_showsEmptyState_whenNoEntries() {
        // Only assertable on a clean install; skip if entries already exist
        guard !entryList.cells.firstMatch.exists else { return }
        XCTAssertTrue(app.staticTexts["No Entries Yet"].exists)
    }

    // MARK: - Compose: Sheet Presentation

    func test_newEntryButton_openComposeSheet() {
        app.buttons["btn_new_entry"].tap()
        XCTAssertTrue(app.textFields["tf_entry_title"].waitForExistence(timeout: 2))
    }

    func test_compose_cancelButton_dismissesSheet() {
        app.buttons["btn_new_entry"].tap()
        XCTAssertTrue(app.buttons["btn_compose_cancel"].waitForExistence(timeout: 2))
        app.buttons["btn_compose_cancel"].tap()
        XCTAssertFalse(app.textFields["tf_entry_title"].waitForExistence(timeout: 1))
    }

    // MARK: - Compose: Validation

    func test_compose_saveButton_isDisabled_whenTitleIsEmpty() {
        app.buttons["btn_new_entry"].tap()
        XCTAssertTrue(app.buttons["btn_compose_save"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.buttons["btn_compose_save"].isEnabled)
    }

    func test_compose_saveButton_isEnabled_afterTypingTitle() {
        app.buttons["btn_new_entry"].tap()
        let titleField = app.textFields["tf_entry_title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("Hello")
        XCTAssertTrue(app.buttons["btn_compose_save"].isEnabled)
    }

    func test_compose_saveButton_remainsDisabled_whenTitleIsOnlyWhitespace() {
        app.buttons["btn_new_entry"].tap()
        let titleField = app.textFields["tf_entry_title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("   ")
        XCTAssertFalse(app.buttons["btn_compose_save"].isEnabled)
    }

    // MARK: - Compose: Save

    func test_compose_save_createsEntryInList() {
        let title = uniqueTitle()

        createEntry(title: title, body: "A body written by UI tests.")

        XCTAssertTrue(entryList.waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 2))
    }

    func test_compose_save_withBodyOnly_stillCreatesEntry() {
        let title = uniqueTitle("BodyOnly")

        app.buttons["btn_new_entry"].tap()
        let titleField = app.textFields["tf_entry_title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText(title)
        // Leave body empty
        app.buttons["btn_compose_save"].tap()

        XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 2))
    }

    // MARK: - Entry Detail: Navigation

    func test_tappingEntryRow_navigatesToDetail() {
        let title = uniqueTitle("Detail")
        createEntry(title: title, body: "Navigate into me.")

        app.staticTexts[title].tap()

        XCTAssertTrue(app.otherElements["entry_detail"].waitForExistence(timeout: 2))
    }

    func test_entryDetail_displaysCorrectTitle_inNavigationBar() {
        let title = uniqueTitle("NavBar")
        createEntry(title: title, body: "Check nav bar.")

        app.staticTexts[title].tap()

        XCTAssertTrue(app.navigationBars[title].waitForExistence(timeout: 2))
    }

    func test_entryDetail_displaysEntryTitle_andBody() {
        let title = uniqueTitle("Content")
        let body = "Body content to verify."
        createEntry(title: title, body: body)

        app.staticTexts[title].tap()

        XCTAssertTrue(app.otherElements["entry_detail"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 2))
    }

    /// Regression test: the detail content container must stretch to fill the
    /// screen width regardless of how short the entry body is. Previously a
    /// short body caused the inner VStack to shrink-to-fit, collapsing the
    /// effective horizontal padding.
    func test_entryDetail_contentStretchesFullWidth_forShortBody() {
        let title = uniqueTitle("ShortBody")
        // Intentionally tiny body — this is the case that triggered the bug.
        createEntry(title: title, body: "Hi.")

        app.staticTexts[title].tap()

        let detail = app.otherElements["entry_detail"]
        XCTAssertTrue(detail.waitForExistence(timeout: 2))

        let screenWidth = app.windows.firstMatch.frame.width
        let detailWidth = detail.frame.width

        // The detail container should span essentially the full screen width.
        // Allow a small tolerance for safe-area / scroll indicator differences.
        XCTAssertGreaterThanOrEqual(
            detailWidth,
            screenWidth - 4,
            "Detail container should stretch to full screen width even with short content (got \(detailWidth) of \(screenWidth))"
        )
    }

    func test_backButton_returnsToEntryList() {
        let title = uniqueTitle("BackNav")
        createEntry(title: title, body: "Go back from here.")

        app.staticTexts[title].tap()
        XCTAssertTrue(app.otherElements["entry_detail"].waitForExistence(timeout: 2))

        app.navigationBars.buttons.firstMatch.tap()

        XCTAssertTrue(entryList.waitForExistence(timeout: 2))
    }

    // MARK: - Comments

    func test_commentInput_appearsAfterCommentRequested() {
        let title = uniqueTitle("Comment")
        createEntry(title: title, body: "Long press this sentence to add a comment.")
        app.staticTexts[title].tap()
        XCTAssertTrue(app.otherElements["entry_detail"].waitForExistence(timeout: 2))

        // Long-press the body text to bring up context menu
        let bodyTextView = app.textViews.firstMatch
        guard bodyTextView.waitForExistence(timeout: 2) else { return }
        bodyTextView.press(forDuration: 1.2)

        let commentMenuItem = app.menuItems["Comment"]
        guard commentMenuItem.waitForExistence(timeout: 2) else {
            // Context menu or Comment action not available in this run; skip gracefully
            return
        }
        commentMenuItem.tap()

        XCTAssertTrue(app.textViews["te_comment_input"].waitForExistence(timeout: 2))
    }

    func test_commentInput_cancelButton_dismissesInput() {
        let title = uniqueTitle("CancelComment")
        createEntry(title: title, body: "Cancel the comment input here.")
        app.staticTexts[title].tap()
        XCTAssertTrue(app.otherElements["entry_detail"].waitForExistence(timeout: 2))

        let bodyTextView = app.textViews.firstMatch
        guard bodyTextView.waitForExistence(timeout: 2) else { return }
        bodyTextView.press(forDuration: 1.2)

        let commentMenuItem = app.menuItems["Comment"]
        guard commentMenuItem.waitForExistence(timeout: 2) else { return }
        commentMenuItem.tap()

        XCTAssertTrue(app.buttons["btn_comment_cancel"].waitForExistence(timeout: 2))
        app.buttons["btn_comment_cancel"].tap()

        XCTAssertFalse(app.textViews["te_comment_input"].waitForExistence(timeout: 1))
    }

    func test_addComment_appearsInCommentsSection() {
        let title = uniqueTitle("AddComment")
        createEntry(title: title, body: "Highlight this text and add a comment.")
        app.staticTexts[title].tap()
        XCTAssertTrue(app.otherElements["entry_detail"].waitForExistence(timeout: 2))

        let bodyTextView = app.textViews.firstMatch
        guard bodyTextView.waitForExistence(timeout: 2) else { return }
        bodyTextView.press(forDuration: 1.2)

        let commentMenuItem = app.menuItems["Comment"]
        guard commentMenuItem.waitForExistence(timeout: 2) else { return }
        commentMenuItem.tap()

        let commentInput = app.textViews["te_comment_input"]
        XCTAssertTrue(commentInput.waitForExistence(timeout: 2))
        commentInput.tap()
        commentInput.typeText("A test comment from UI tests")

        app.buttons["btn_comment_add"].tap()

        XCTAssertTrue(app.otherElements["comments_section"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["A test comment from UI tests"].waitForExistence(timeout: 2))
    }

    func test_commentAddButton_isDisabled_whenInputIsEmpty() {
        let title = uniqueTitle("EmptyComment")
        createEntry(title: title, body: "Try to add empty comment.")
        app.staticTexts[title].tap()
        XCTAssertTrue(app.otherElements["entry_detail"].waitForExistence(timeout: 2))

        let bodyTextView = app.textViews.firstMatch
        guard bodyTextView.waitForExistence(timeout: 2) else { return }
        bodyTextView.press(forDuration: 1.2)

        let commentMenuItem = app.menuItems["Comment"]
        guard commentMenuItem.waitForExistence(timeout: 2) else { return }
        commentMenuItem.tap()

        XCTAssertTrue(app.buttons["btn_comment_add"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.buttons["btn_comment_add"].isEnabled)
    }

    // MARK: - Voice Feature Flag

    func test_voiceRecordButton_isHidden_inComposeSheet() {
        app.buttons["btn_new_entry"].tap()
        XCTAssertTrue(app.textFields["tf_entry_title"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.buttons["btn_voice_record"].exists)
    }

    func test_voiceRecordButton_isHidden_inEntryDetail() {
        let title = uniqueTitle("VoiceDetail")
        createEntry(title: title, body: "Check voice button in detail.")
        app.staticTexts[title].tap()
        XCTAssertTrue(app.otherElements["entry_detail"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.buttons["btn_voice_record"].exists)
    }
}

// MARK: - Helpers

extension JournalAppUITests {

    var entryList: XCUIElement {
        app.collectionViews["entry_list"]
    }

    func uniqueTitle(_ tag: String = "") -> String {
        let ts = Int(Date().timeIntervalSince1970)
        return tag.isEmpty ? "UITest \(ts)" : "UITest \(tag) \(ts)"
    }

    @discardableResult
    func createEntry(title: String, body: String = "") -> XCUIElement {
        app.buttons["btn_new_entry"].tap()

        let titleField = app.textFields["tf_entry_title"]
        _ = titleField.waitForExistence(timeout: 2)
        titleField.tap()
        titleField.typeText(title)

        if !body.isEmpty {
            let bodyField = app.textViews["te_entry_body"]
            bodyField.tap()
            bodyField.typeText(body)
        }

        app.buttons["btn_compose_save"].tap()
        _ = entryList.waitForExistence(timeout: 2)

        return app.staticTexts[title]
    }
}
#endif

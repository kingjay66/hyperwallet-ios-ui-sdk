import XCTest

class UiSelectDestination {
   let defaultTimeout = 5.0

    var app: XCUIApplication

    var createTransferTableView: XCUIElement
    var destinationHeader: XCUIElement
    var tranferHeader: XCUIElement
    var amountLabel: XCUIElement
    var noteHeader: XCUIElement
    var transferAllFundswitch: XCUIElement
    var transferAmountTextField: XCUIElement

    init(app: XCUIApplication) {
        self.app = app
        createTransferTableView = app.tables["createTransferTableView"]
        destinationHeader = createTransferTableView.staticTexts["DESTINATION"]
        tranferHeader = createTransferTableView.staticTexts["TRANSFER"]
        noteHeader = createTransferTableView.staticTexts["NOTES"]
        amountLabel = createTransferTableView.staticTexts["Amount"]
        transferAllFundswitch = app.switches["transferAllFundsSwitch"]
        transferAmountTextField = app.textFields["transferAmountTextField"]
    }
    func clickBackButton() {
        app.navigationBars.buttons["Back"].tap()
    }

    func selectDestination(_ title: String, _ detail: String) {
        app.cells.staticTexts[detail].tap()
    }

    func enableSwitch() {
        transferAllFundswitch.tap()
    }
}

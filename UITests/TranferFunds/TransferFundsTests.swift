import XCTest

class TranferFunds: BaseTests {
    var transferFunds: TransferFunds!

    let bankAccount = NSPredicate(format: "label CONTAINS[c] 'Bank Account'")

    var firstCellTextLbl: String = {
        if #available(iOS 11.2, *) {
            return "PayPal"
        } else {
            return "PayPal"
        }
    }()

    var firstCelldetailLbl: String = {
        if #available(iOS 11.2, *) {
            return "United States\ncarroll.lynn@byteme.com"
        } else {
            return "United States\ncarroll.lynn@byteme.com"
        }
    }()

    var selectData: String = "Canada\ncarroll.lynn@byteme.com"

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()

        app.tables.cells.containing(.staticText, identifier: "Transfer Funds").element(boundBy: 0).tap()
        spinner = app.activityIndicators["activityIndicator"]
        waitForNonExistence(spinner)
        transferFunds = TransferFunds(app: app)
    }

    func testTransferFundsAndSelectDetinationScreenVerification() {
        //verfiy user can able to navigate the Transfer funds Screen
        XCTAssert(app.navigationBars["Transfer Funds"].exists)
        XCTAssert(transferFunds.destinationHeader.exists)
        XCTAssert(transferFunds.tranferHeader.exists)
        XCTAssert(transferFunds.noteHeader.exists)
        XCTAssertTrue(app.cells.element(boundBy: 0).staticTexts[firstCellTextLbl].exists)
        XCTAssertTrue(app.cells.element(boundBy: 0).staticTexts[firstCelldetailLbl].exists)

        app.tables.cells.containing(.staticText, identifier: "PayPal").element(boundBy: 0).tap()
        XCTAssert(app.navigationBars["Select Destination"].exists)
        transferFunds.clickBackButton()

        XCTAssert(app.navigationBars["Transfer Funds"].exists)
        app.cells.containing(.staticText, identifier: "PayPal").element(boundBy: 0).tap()

        XCTAssert(app.navigationBars["Select Destination"].exists)
        transferFunds.selectDestination(firstCellTextLbl, selectData)

        XCTAssert(app.navigationBars["Transfer Funds"].exists)
        XCTAssert(app.navigationBars["Transfer Funds"].exists)

        XCTAssertTrue(app.cells.element(boundBy: 0).staticTexts[firstCellTextLbl].exists)
        XCTAssertTrue(app.cells.element(boundBy: 0).staticTexts[selectData].exists)

        XCTAssertTrue(app.cells.element(boundBy: 1).staticTexts["CAD"].exists)
        XCTAssertTrue(transferFunds.transferAmountTextField.exists)

        XCTAssertNotNil(app.tables.otherElements
            .containing(NSPredicate(format: "label CONTAINS %@",
                                    "124.75")))

        XCTAssertEqual(transferFunds.transferAllFundswitch.value as? String, "0")

        transferFunds.enableSwitch()

        XCTAssertEqual(transferFunds.transferAllFundswitch.value as? String, "1")

        XCTAssertEqual(transferFunds.transferAmountTextField.value as? String, "124.75")

        XCTAssertTrue(app.cells.element(boundBy: 1).staticTexts["CAD"].exists)
    }
}

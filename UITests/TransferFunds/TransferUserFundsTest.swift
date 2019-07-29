import XCTest

class TransferUserFundsTest: BaseTests {
    var transferFundMenu: XCUIElement!
    var transferFunds: TransferFunds!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
        spinner = app.activityIndicators["activityIndicator"]
        transferFundMenu = app.tables.cells
            .containing(.staticText, identifier: "Transfer Funds")
            .element(boundBy: 0)
        transferFunds = TransferFunds(app: app)
    }

    override func tearDown() {
        mockServer.tearDown()
    }

    /*
     Given that no Transfer methods have been created
     When module is loaded
     Then the user will have the ability to create a method
     */
    func testTransferFunds_noTransferMethod() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListNoTransferMethod",
                             method: HTTPMethod.get)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundUSD",
                             method: HTTPMethod.post)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)

        // Assert Add Destination Section
        // how to we assert the icon
        XCTAssertEqual(transferFunds.addSelectDestinationSectionLabel.label, "DESTINATION")
        XCTAssertEqual(transferFunds.addSelectDestinationLabel.label, "Add Account")
        XCTAssertEqual(transferFunds.addSelectDestinationDetailLabel.label, "An account hasn't been set up yet, please add an account first")

        //  TODO: Tab to Add Account (we will not assert at this point)
        XCTAssertTrue(transferFunds.transferCurrency.exists, "Transfer Currency should not exist")
    }

    /*
     Given that Transfer methods exist
     When module is loaded
     Then first available transfer method will be selected
     */
    func testTransferFunds_firstAvailableMethodIsSelected() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListMoreThanOneTransferMethod",
                             method: HTTPMethod.get)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundUSD",
                             method: HTTPMethod.post)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)

        // Assert Add Destination Section
        XCTAssertEqual(transferFunds.addSelectDestinationSectionLabel.label, "DESTINATION")
        XCTAssertEqual(transferFunds.addSelectDestinationLabel.label, "Bank Account")
        XCTAssertEqual(transferFunds.addSelectDestinationDetailLabel.label, "")
        // Assert Transfer Section

        XCTAssertEqual(transferFunds.transferSectionLabel.label, "TRANSER")
        // Amount row
        XCTAssertEqual(transferFunds.transferAmountLabel.label, "Amount")
        XCTAssertEqual(transferFunds.transferCurrency.label, "")
        // Transfer all funds row
        XCTAssertEqual(transferFunds.transferAllFundsLabel.label, "Transfer all funds")
        XCTAssertTrue(transferFunds.transferAllFundsSwitch.exists, "Transfer all funds switch should exist")

        XCTAssertEqual(transferFunds.notesSectionLabel.label, "NOTES")
        XCTAssertEqual(transferFunds.notesPlaceHolder.label, "Description")

        // Assert "Transfer all funds"
        XCTAssertTrue(transferFunds.nextButton.exists && transferFunds.nextButton.isEnabled)
    }

    /*
     Given that Transfer methods exist
     When user select a different transfer method with different currency
     Then the destination currency should be updated AND Then Payee can enter the amount
     */
    func testTransferFunds_switchTransferMethod_Currency() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListMoreThanOneTransferMethod",
                             method: HTTPMethod.get)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundUSD",
                             method: HTTPMethod.post)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)

        // TODO: implement assertion
        //  1. Select Destination (USD)
        // the currency of the method will be shown AND the Currency Abbreviation should be adapted based on the Destination account selected

        // Amount row
        XCTAssertEqual(transferFunds.transferAmountLabel.label, "Amount")
        XCTAssertEqual(transferFunds.transferCurrency.label, "")
        // TODO: Switch to another bank account
        XCTAssertEqual(transferFunds.transferCurrency.label, "")
    }

    /*
     Given thatTransfer methods exist
     AND PrepaidCard Transfer method is selected
     When Payee enters the amount and Notes
     Then Next button is enabled
     */
    func testTransferFunds_createTransferPrepaidCardWithNotes() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListOnePrepaidCardTransferUSD",
                             method: HTTPMethod.get)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundUSD",
                             method: HTTPMethod.post)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "createTransferWithoutFX",
                             method: HTTPMethod.post)

        mockServer.setupStub(url: "/rest/v3/transfers/trf-token/status-transitions",
                             filename: "transferStatusQuoted",
                             method: HTTPMethod.post)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)

        // TODO: implement assertion
        // TODO: Assert Note entry
        XCTAssertEqual(transferFunds.notesSectionLabel.label, "NOTES")
        XCTAssertEqual(transferFunds.notesPlaceHolder.label, "Description")
        let testInput = "Transfer test"
        transferFunds.notesPlaceHolder.clearAndEnterText(text: testInput)
        XCTAssertEqual(transferFunds.notesPlaceHolder.label, testInput)
    }

    func testTransferFund_createTransferWithAllFunds() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListOneBankAccountTransferUSD",
                             method: HTTPMethod.get)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundUSD",
                             method: HTTPMethod.get)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "CreateTransferWithFX",
                             method: HTTPMethod.post)

        //        mockServer.setupStub(url: "/rest/v3/transfers/trf-token/status-transitions",
        //                             filename: "transferStatusQuoted",
        //                             method: HTTPMethod.post)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)

        // TODO: implement assertion
        // Transfer all funds row
        XCTAssertEqual(transferFunds.transferAllFundsLabel.label, "Transfer all funds")
        XCTAssertTrue(transferFunds.transferAllFundsSwitch.exists, "Transfer all funds switch should exist")
        // turn the switch on
        transferFunds.transferAllFundsSwitch.tap()
        // Assert the full amount
        XCTAssertEqual(transferFunds.availableForTransferLabel.label, "Available for transfer")
        XCTAssertEqual(transferFunds.availableBalance.label, "0.00")
    }

    /* Given that User has 2 bank accounts which has different Currency from the Source.
     When user transfer the fund
     Then the user should see 2 FX quotes
     */
    // Transfer Requiring more than 2 FX
    func testTransferFund_createTransferWithFX() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListOneBankAccountTransferUSD",
                             method: HTTPMethod.get)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundUSD",
                             method: HTTPMethod.post)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "createTransferWithFX",
                             method: HTTPMethod.get)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)
    }

    func testTransferFund_createTransferWithoutFX() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListOneBankAccountTransferUSD",
                             method: HTTPMethod.get)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundUSD",
                             method: HTTPMethod.post)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "createTransferWithoutFX",
                             method: HTTPMethod.get)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)
    }

    /*
     Given thatTransfer methods exist
     AND PrepaidCard Transfer method is selected
     When Payee enters the amount
     Then Next button is enabled
     */
    func testTransferFunds_createTransferDestinationAmount_JPY() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListOneBankAccountTransferJPY",
                             method: HTTPMethod.get)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundJPY",
                             method: HTTPMethod.get)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)

        XCTAssertEqual(transferFunds.transferSectionLabel.label, "TRANSER")
        XCTAssertEqual(transferFunds.transferAmountLabel.label, "Amount")
        XCTAssertEqual(transferFunds.transferCurrency.label, "JPY")

        XCTAssertEqual(transferFunds.availableForTransferLabel.label, "Available for transfer")
        XCTAssertEqual(transferFunds.availableBalance.label, "")
    }

    /* Given that user is on the Transfer fund page and selected a Transfer Destination
     When user enter the digit for the transfer amount
     Then amount field will be formatted correctly
     */
    func testTransferFund_createTransferWhenDestinationAmountIsSet() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListOneBankAccountTransferUSD",
                             method: HTTPMethod.get)
        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundUSD",
                             method: HTTPMethod.post)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)

        // TODO: Validate the transfer amount input
        transferFunds.transferAmount.typeText("9")
        XCTAssertEqual(transferFunds.transferAmount.label, "0.09")
        transferFunds.transferAmount.typeText("4")
        XCTAssertEqual(transferFunds.transferAmount.label, "0.94")
        transferFunds.transferAmount.typeText("2")
        XCTAssertEqual(transferFunds.transferAmount.label, "9.42")
        transferFunds.transferAmount.typeText("3")
        XCTAssertEqual(transferFunds.transferAmount.label, "94.23")
    }

    func testTransferFund_createTransferWhenDestinationAmountNotSet() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListOneBankAccountTransferUSD",
                             method: HTTPMethod.get)
        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundUSD",
                             method: HTTPMethod.post)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)

        // Assert NEXT button is disabled ??
    }

    func testTransferFund_createTransferWhenDestinationNotSet() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListOneBankAccountTransferUSD",
                             method: HTTPMethod.get)
        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundUSD",
                             method: HTTPMethod.post)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)

        // Assert NEXT button is disabled ??
    }

    /* Given that Transfer methods exist
     When user transfers the fund
     Then the over limit error occurs and the app should display the error
     (Your attempted transaction has exceeded the approved payout limit)
     If someone transfers > what is maximally transferable by the account
     */
    func testTransferFunds_createTransferOverLimitError() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListOneBankAccountTransferUSD",
                             method: HTTPMethod.get)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundUSD",
                             method: HTTPMethod.post)

        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "TransferErrorOverMaxAmount",
                             method: HTTPMethod.get)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)

        // TODO: implement assertion
        XCTAssert(app.alerts["Error"].exists)
        let predicate = NSPredicate(format:
            "label CONTAINS[c] 'Your attempted transaction has exceeded the approved payout limit; please contact Hyperwallet for further assistance.'")
        XCTAssert(app.alerts["Error"].staticTexts.element(matching: predicate).exists)
    }

    /* Given that Transfer methods exist And insufficient funds to transfer
     When user transfers the fund
     Then the over available Fund error occurs and the app should display the error
     */
    func testTransferFund_createTransferInsufficientFundsError() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListOneBankAccountTransferUSD",
                             method: HTTPMethod.get)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundInsufficient",
                             method: HTTPMethod.post)

        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "TransferErrorAmountLessThantFee",
                             method: HTTPMethod.get)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)

        XCTAssert(app.alerts["Error"].exists)
        let predicate = NSPredicate(format:
            "label CONTAINS[c] 'You do not have enough funds in any single currency to complete this transfer'")
        XCTAssert(app.alerts["Error"].staticTexts.element(matching: predicate).exists)
    }

    // ??
    func testTransferFund_createTransferMinimumAmountError() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "ListOneBankAccountTransferUSD",
                             method: HTTPMethod.get)

        mockServer.setupStub(url: "/rest/v3/transfers",
                             filename: "AvailableFundZero",
                             method: HTTPMethod.post)

        mockServer.setupStub(url: "/rest/v3/users/usr-token/transfer-methods",
                             filename: "transfer_error_amount_less_than_the_fee",
                             method: HTTPMethod.get)

        XCTAssertTrue(transferFundMenu.exists)
        transferFundMenu.tap()
        waitForNonExistence(spinner)

        XCTAssert(app.alerts["Error"].exists)
        let predicate = NSPredicate(format:
            "label CONTAINS[c] 'Amount is less than the fee amount'")
        XCTAssert(app.alerts["Error"].staticTexts.element(matching: predicate).exists)
    }

    func testTransferFund_createTransferInvalidSourceError() {
    }

    func testTransferFund_createTransferConnectionError() {
    }
}

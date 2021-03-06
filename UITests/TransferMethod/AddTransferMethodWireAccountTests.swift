import XCTest

class AddTransferMethodWireAccountIndividualTests: BaseTests {
    var selectTransferMethodType: SelectTransferMethodType!
    var addTransferMethod: AddTransferMethod!

    let wireAccount = NSPredicate(format: "label CONTAINS[c] 'Wire Transfer'")

    override func setUp() {
        super.setUp()

        app = XCUIApplication()
        app.launchEnvironment = [
            "COUNTRY": "US",
            "CURRENCY": "USD",
            "ACCOUNT_TYPE": "WIRE_ACCOUNT",
            "PROFILE_TYPE": "INDIVIDUAL"
        ]
        app.launch()

        mockServer.setupStub(url: "/graphql",
                             filename: "TransferMethodConfigurationWireAccountResponse",
                             method: HTTPMethod.post)

        app.tables.cells.staticTexts["Add Transfer Method"].tap()
        spinner = app.activityIndicators["activityIndicator"]
        waitForNonExistence(spinner)
        addTransferMethod = AddTransferMethod(app: app)
    }

    func testAddTransferMethod_displaysElementsOnTmcResponse() {
        XCTAssert(app.navigationBars["Wire Account"].exists)

        verifyAccountInformationSection()
        verifyIntermediaryAccountSection()
        verifyIndividualAccountHolderSection()
        verifyAddressSection()
        verifyDefaultValues()

        XCTAssert(addTransferMethod.transferMethodInformationHeader.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.staticTexts["Transaction Fees: USD 20.00"].exists)

        addTransferMethod.addTransferMethodTableView.scroll(to: addTransferMethod.createTransferMethodButton)
        XCTAssert(addTransferMethod.createTransferMethodButton.exists)
    }

    func testAddTransferMethod_returnsErrorOnInvalidPresence() {
        addTransferMethod.setBankId("")
        addTransferMethod.setBranchId("")
        addTransferMethod.setBankAccountId("")

        addTransferMethod.clickCreateTransferMethodButton()

        XCTAssert(app.tables["addTransferMethodTable"].staticTexts["bankId_error"].exists)
        XCTAssert(app.tables["addTransferMethodTable"].staticTexts["branchId_error"].exists)
        XCTAssert(app.tables["addTransferMethodTable"].staticTexts["bankAccountId_error"].exists)
    }

    func testAddTransferMethod_returnsErrorOnInvalidPattern() {
        addTransferMethod.setBankId("1a-31a")
        addTransferMethod.setBranchId("abc123abc")
        addTransferMethod.setBankAccountId(".1a-31a")

        addTransferMethod.clickCreateTransferMethodButton()

        XCTAssert(app.tables["addTransferMethodTable"].staticTexts["bankId_error"].exists)
        XCTAssert(app.tables["addTransferMethodTable"].staticTexts["branchId_error"].exists)
        XCTAssert(app.tables["addTransferMethodTable"].staticTexts["bankAccountId_error"].exists)
    }

    func testAddTransferMethod_returnsErrorOnInvalidLength() {
        addTransferMethod.setBranchId("")
        addTransferMethod.setBankId("")
        addTransferMethod.setBankAccountId("")

        addTransferMethod.clickCreateTransferMethodButton()

        XCTAssert(app.tables["addTransferMethodTable"].staticTexts["bankId_error"].exists)
        XCTAssert(app.tables["addTransferMethodTable"].staticTexts["branchId_error"].exists)
        XCTAssert(app.tables["addTransferMethodTable"].staticTexts["bankAccountId_error"].exists)
    }

    func testAddTransferMethod_createBankAccount() {
        mockServer.setupStub(url: "/rest/v3/users/usr-token/bank-accounts",
                             filename: "WireAccountIndividualResponse",
                             method: HTTPMethod.post)

        waitForNonExistence(spinner)

        addTransferMethod.setBankId("HGASUS31")
        addTransferMethod.setBranchId("026009593")
        addTransferMethod.setBankAccountId("675825208")

        addTransferMethod.setAdditionalWireInstructions("This is instruction")
        addTransferMethod.setIntermediaryBankId("ELREUS44")
        addTransferMethod.setIntermediaryBankAccountId("246810")

        addTransferMethod.setFirstName("Tommy")
        addTransferMethod.setLastName("Gray")
        addTransferMethod.setMiddleName("Adam")
        addTransferMethod.setDateOfBirth(yearOfBirth: "1980", monthOfBirth: "January", dayOfBirth: "1")

        addTransferMethod.setPhoneNumber("604-345-1777")
        addTransferMethod.setMobileNumber("604-345-1888")

        addTransferMethod.selectCountry("United States")
        addTransferMethod.setStateProvince("CA")
        addTransferMethod.setStreet("575 Market Street")
        addTransferMethod.setCity("San Francisco")
        addTransferMethod.setPostalCode("94105")

        addTransferMethod.clickCreateTransferMethodButton()

        waitForNonExistence(spinner)

        XCTAssert(app.navigationBars["Account Settings"].exists)
    }
}

private extension AddTransferMethodWireAccountIndividualTests {
    func verifyAccountInformationSection() {
        XCTAssert(addTransferMethod.addTransferMethodTableView
            .staticTexts["Account Information - United States (USD)"].exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.cells.staticTexts["BIC/SWIFT"].exists)
        XCTAssert(addTransferMethod.bankIdInput.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.cells.staticTexts["Routing Number"].exists)
        XCTAssert(addTransferMethod.branchIdInput.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.staticTexts["Account Number OR IBAN"].exists)
        XCTAssert(addTransferMethod.bankAccountIdInput.exists)
    }

    func verifyIntermediaryAccountSection() {
        XCTAssert(addTransferMethod.intermediaryAccountHeader.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.cells
            .staticTexts["Additional Wire Instructions"].exists)
        XCTAssert(addTransferMethod.wireInstructionsInput.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.cells
            .staticTexts["Intermediary BIC / SWIFT Code"].exists)
        XCTAssert(addTransferMethod.intermediaryBankIdInput.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.cells
            .staticTexts["Intermediary Account Number"].exists)
        XCTAssert(addTransferMethod.intermediaryBankAccountIdInput.exists)
    }

    func verifyIndividualAccountHolderSection() {
        XCTAssert(addTransferMethod.accountHolderHeader.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.staticTexts["First Name"].exists)
        XCTAssert(addTransferMethod.firstNameInput.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.staticTexts["Middle Name"].exists)
        XCTAssert(addTransferMethod.lastNameInput.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.staticTexts["Last Name"].exists)
        XCTAssert(addTransferMethod.middleNameInput.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.staticTexts["Date of Birth"].exists)
        XCTAssert(addTransferMethod.dateOfBirthInput.exists)
    }

    func verifyContactInformationSection() {
        XCTAssert(addTransferMethod.contactInformationHeader.exists )
        XCTAssert(addTransferMethod.addTransferMethodTableView.staticTexts["Phone Number"].exists)
        XCTAssert(addTransferMethod.phoneNumberInput.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.staticTexts["Mobile Number"].exists)
        XCTAssert(addTransferMethod.mobileNumberInput.exists)
    }

    func verifyAddressSection() {
        XCTAssert(addTransferMethod.addressHeader.exists)
        XCTAssert(addTransferMethod.countrySelect.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.staticTexts["State/Province"].exists)
        XCTAssert(addTransferMethod.stateProvinceInput.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.staticTexts["Street"].exists)
        XCTAssert(addTransferMethod.addressLineInput.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.staticTexts["City"].exists)
        XCTAssert(addTransferMethod.cityInput.exists)
        XCTAssert(addTransferMethod.addTransferMethodTableView.staticTexts["Zip/Postal Code"].exists)
        XCTAssert(addTransferMethod.postalCodeInput.exists)
    }

    func verifyDefaultValues() {
        XCTAssertEqual(addTransferMethod.bankIdInput.value as? String, "")
        XCTAssertEqual(addTransferMethod.branchIdInput.value as? String, "")
        XCTAssertEqual(addTransferMethod.bankAccountIdInput.value as? String, "")

        XCTAssertEqual(addTransferMethod.wireInstructionsInput.value as? String, "")
        XCTAssertEqual(addTransferMethod.intermediaryBankIdInput.value as? String, "")
        XCTAssertEqual(addTransferMethod.intermediaryBankAccountIdInput.value as? String, "")

        XCTAssertEqual(addTransferMethod.firstNameInput.value as? String, "Craig")
        XCTAssertEqual(addTransferMethod.middleNameInput.value as? String, "")
        XCTAssertEqual(addTransferMethod.lastNameInput.value as? String, "Brenden")
        XCTAssertEqual(addTransferMethod.dateOfBirthInput.value as? String, "January 1, 1980")

        XCTAssertEqual(addTransferMethod.phoneNumberInput.value as? String, "+1 604 6666666")
        XCTAssertEqual(addTransferMethod.mobileNumberInput.value as? String, "604 666 6666")

        XCTAssert(addTransferMethod.addTransferMethodTableView.cells.staticTexts["Canada"].exists)
        XCTAssertEqual(addTransferMethod.stateProvinceInput.value as? String, "BC")
        XCTAssertEqual(addTransferMethod.addressLineInput.value as? String, "950 Granville Street")
        XCTAssertEqual(addTransferMethod.cityInput.value as? String, "Vancouver")
        XCTAssertEqual(addTransferMethod.postalCodeInput.value as? String, "V6Z1L2")
    }
}

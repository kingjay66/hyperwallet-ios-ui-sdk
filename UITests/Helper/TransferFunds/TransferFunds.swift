import Common
import XCTest

// Transfer Funds Page Object
class TransferFunds {
    var app: XCUIApplication

    var transferFundTitle: XCUIElement

    var addSelectDestinationSectionLabel: XCUIElement

    var addSelectDestinationPlaceholder: XCUIElement

    var addSelectDestinationLabel: XCUIElement

    var addSelectDestinationDetailLabel: XCUIElement

    var transferSectionLabel: XCUIElement

    var transferAmountLabel: XCUIElement

    var transferAmount: XCUIElement

    var transferCurrency: XCUIElement

    var transferAllFundsLabel: XCUIElement

    var transferAllFundsSwitch: XCUIElement

    var availableForTransferLabel: XCUIElement

    var availableForAmount: XCUIElement

    var notesSectionLabel: XCUIElement

    var notesPlaceHolderString: String

    var notesDescription: XCUIElement

    var notesDescriptionOptionLabel: XCUIElement

    var availableBalance: XCUIElement

    var nextButton: XCUIElement

    init(app: XCUIApplication) {
        self.app = app

        transferFundTitle = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        addSelectDestinationSectionLabel = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        addSelectDestinationLabel = app.tables["createTransferTableView"].staticTexts["createTransferAddSelectDestinationCellTextLabel"]

        addSelectDestinationPlaceholder = app.tables["createTransferTableView"].staticTexts["createTransferAddSelectDestinationCellTextLabel"]


        addSelectDestinationDetailLabel = app.tables["createTransferTableView"].staticTexts["createTransferAddSelectDestinationCellDetailTextLabel"]

        transferSectionLabel = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        transferAmountLabel = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        transferAmount = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        transferCurrency = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        transferAllFundsLabel = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        transferAllFundsSwitch = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        availableForTransferLabel = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        availableForAmount = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        notesSectionLabel = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        notesPlaceHolderString = "transfer_description".localized()

        notesDescription = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        notesDescriptionOptionLabel = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        availableBalance = app.tables["createTransferTableView"].staticTexts["available_balance_footer"]
        nextButton = app.tables["createTransferTableView"].staticTexts["add_transfer_next_button"]
    }
}

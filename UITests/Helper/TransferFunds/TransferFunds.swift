import Common
import XCTest

// Transfer Funds Page Object
class TransferFunds {
    var app: XCUIApplication

    var transferFundTitle: XCUIElement

    var addSelectDestinationSectionLabel: XCUIElement

    var addSelectDestinationPlaceholderString: String

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

        addSelectDestinationLabel = app.tables["createTransferTableView"].staticTexts["transferDestinationTitleLabel"]

        addSelectDestinationPlaceholderString = ""

        addSelectDestinationDetailLabel = app.tables["createTransferTableView"].staticTexts["transferDestinationSubtitleLabel"]

        transferSectionLabel = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        transferAmountLabel = app.tables["createTransferTableView"].staticTexts["transferAmountTitleLabel"]

        transferAmount = app.tables["createTransferTableView"].staticTexts["transferAmountTextField"]

        transferCurrency = app.tables["createTransferTableView"].staticTexts["transferAmountCurrencyLabel"]

        transferAllFundsLabel = app.tables["createTransferTableView"].staticTexts["transferAllFundsTitleLabel"]

        transferAllFundsSwitch = app.tables["createTransferTableView"].staticTexts["transferAllFundsSwitch"]

        availableForTransferLabel = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        availableForAmount = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        notesSectionLabel = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        notesPlaceHolderString = "transfer_description".localized()

        notesDescription = app.tables["createTransferTableView"].staticTexts["transferNotesTextField"]

        notesDescriptionOptionLabel = app.tables["createTransferTableView"].staticTexts["receiptTransactionTypeLabel"]

        availableBalance = app.tables["createTransferTableView"].staticTexts["available_balance_footer"]

        nextButton = app.tables["createTransferTableView"].staticTexts["addTransferNextButton"]
    }
}

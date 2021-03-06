// Copyright 2018 - Present Hyperwallet
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import HyperwalletSDK
import UIKit

/// Controller to create a new transfer method.
///
/// The form fields are based on the country, currency, user's profile type and transfer method type should be passed
/// to this Controller to create new Transfer Method for those values.
public final class AddTransferMethodTableViewController: UITableViewController {
    typealias ButtonHandler = () -> Void
    private var defaultHeaderHeight = CGFloat(38.0)

    private let emptyHeaderHeight: CGFloat = {
        if #available(iOS 11.0, *) {
            return CGFloat(1.0)
        } else {
            return CGFloat(16.0)
        }
    }()

    // MARK: - Properties -
    /// The completion handler will be performed after a new transfer method has been created.
    public var createTransferMethodHandler: ((HyperwalletTransferMethod) -> Void)?
    private var country: String
    private var currency: String
    private var profileType: String
    private var transferMethodTypeCode: String
    private var processingView: ProcessingView?
    private var spinnerView: SpinnerView?
    private var presenter: AddTransferMethodPresenter!
    private var widgets = [AbstractWidget]()
    // MARK: - Button -
    private lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(
            greaterThanOrEqualToConstant: Theme.Cell.smallHeight).isActive = true

        button.accessibilityLabel = "create_account_label".localized()
        button.accessibilityIdentifier = "createAccountButton"
        button.setTitle("create_account_label".localized(), for: .normal)
        button.setTitleColor(Theme.Button.color, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
        return button
    }()

    @objc
    private func onTapped() {
        presenter.createTransferMethod()
    }

    private lazy var infoView: UIStackView = {
        let label = UILabel()
        label.numberOfLines = 0

        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: CGFloat(8.0),
            left: CGFloat(0.0),
            bottom: CGFloat(8.0),
            right: CGFloat(16.0)
        )
        return stackView
    }()

    // MARK: - View Lifecycle -
    /// Creates a new instance of the `AddTransferMethodTableViewController`
    ///
    /// - Parameters:
    ///   - country: The 2 letter ISO 3166-1 country code.
    ///   - currency: The 3 letter ISO 4217-1 currency code.
    ///   - profileType: The profile type. Possible values - INDIVIDUAL, BUSINESS.
    ///   - transferMethodTypeCode: The transfer method type. Possible values - BANK_ACCOUNT, BANK_CARD.
    init(_ country: String,
         _ currency: String,
         _ profileType: String,
         _ transferMethodTypeCode: String) {
        self.country = country
        self.currency = currency
        self.profileType = profileType
        self.transferMethodTypeCode = transferMethodTypeCode
        super.init(nibName: nil, bundle: nil)
    }

    // swiftlint:disable unavailable_function
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        title = transferMethodTypeCode.lowercased().localized()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tap)
        initializePresenter()
        setupLayout()
        hideKeyboardWhenTappedAround()
        navigationItem.backBarButtonItem = UIBarButtonItem.back
    }

    // MARK: - Setup Layout -
    private func setupLayout() {
        setViewBackgroundColor()
        setupTableView()
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Theme.Cell.smallHeight
        tableView.accessibilityIdentifier = "addTransferMethodTable"
        tableView.register(
            AddTransferMethodTableViewCell.self,
            forCellReuseIdentifier: AddTransferMethodTableViewCell.reuseIdentifier
        )
    }

    @objc
    func handleTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    private func initializePresenter() {
        presenter = AddTransferMethodPresenter(self,
                                               country,
                                               currency,
                                               profileType,
                                               transferMethodTypeCode)
        presenter.loadTransferMethodConfigurationFields()
    }
}

// MARK: - TableViewController Data source and delegate
extension AddTransferMethodTableViewController {
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.sectionData[section].header
    }

    override public func tableView(_ tableView: UITableView,
                                   willDisplayHeaderView view: UIView,
                                   forSection section: Int) {
        guard let headerView = view as?  UITableViewHeaderFooterView
            else {
                return
        }
        headerView.textLabel?.textColor = Theme.Label.textColor
    }

    override public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footerText = ""
        if let errorMessage = presenter.sectionData[section].errorMessage {
            footerText = String(format: "%@", errorMessage)
        }
        return footerText
    }

    override public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let header = presenter.sectionData[section].header {
            if header.height(withConstrainedWidth: self.view.frame.width,
                             font: UIFont.preferredFont(forTextStyle: .body)) > defaultHeaderHeight {
                return UITableView.automaticDimension
            } else {
                return defaultHeaderHeight
            }
        } else {
            return emptyHeaderHeight
        }
    }

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sectionData.count
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.sectionData[section].count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddTransferMethodTableViewCell.reuseIdentifier)
            else {
                fatalError("Can't dequeue the cell")
        }
        let widget = presenter.sectionData[indexPath.section][indexPath.row]
        cell.contentView.addSubview(widget)
        if let widget = widget as? SelectionWidget, widget.field.isEditable ?? true {
            cell.accessoryType = .disclosureIndicator
            widget.viewController = self
        }

        let leftAnchor = widget.safeAreaLeadingAnchor
            .constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor)
        leftAnchor.priority = UILayoutPriority(999)

        let topAnchor = widget.topAnchor.constraint(equalTo: cell.contentView.topAnchor)
        topAnchor.priority = UILayoutPriority(999)

        let rightAnchor = widget.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor)
        rightAnchor.priority = UILayoutPriority(999)

        let bottomAnchor = widget.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        bottomAnchor.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([leftAnchor, topAnchor, rightAnchor, bottomAnchor])

        return cell
    }
}

// MARK: - Presenter - AddTransferMethodView -
extension AddTransferMethodTableViewController: AddTransferMethodView {
    private func getSectionContainingFocusedField() -> AddTransferMethodSectionData? {
        return presenter.sectionData.first(where: { $0.containsFocusedField == true })
    }

    private func getSectionIndex(by fieldGroup: String) -> Int? {
        return presenter.sectionData.firstIndex(where: { $0.fieldGroup == fieldGroup })
    }

    private func focusField(in section: AddTransferMethodSectionData) {
        section.fieldToBeFocused?.focus()
        section.reset()
    }

    func showFooterViewWithUpdatedSectionData(for sections: [AddTransferMethodSectionData]) {
        for section in sections {
            if let sectionIndex = getSectionIndex(by: section.fieldGroup) {
                if let footerView = tableView.footerView(forSection: sectionIndex) {
                    // section is visible, update footer
                    updateFooterView(footerView, for: sectionIndex)
                }
            }
        }

        //even though the footer is visible, the cell might not be visible. So we need to check if the field that needs
        // to be focused is visible. We need to scroll to the field in order to focus.
        if let section = getSectionContainingFocusedField() {
            let indexPath = getIndexPath(for: section)
            if isCellVisibile(indexPath) {
                focusField(in: section)
            } else {
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }

    override public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // update footer once scroll ends
        if let section = getSectionContainingFocusedField() {
            if isCellVisibile(getIndexPath(for: section)) {
                focusField(in: section)
            }
        }
    }

    func fieldValues() -> [(name: String, value: String)] {
        return widgets.map { (name: $0.name(), value: $0.value()) }
    }

    func areAllFieldsValid() -> Bool {
        var isFormValid = true
        widgets.forEach {
            if $0.isValid() == false {
                $0.showError()
                if isFormValid {
                    focusOnInvalidField($0)
                }
                isFormValid = false
            }
        }
        return isFormValid
    }

    func showLoading() {
        if let view = self.navigationController?.view {
            spinnerView = HyperwalletUtilViews.showSpinner(view: view)
        }
    }

    func hideLoading() {
        if let spinnerView = spinnerView {
            HyperwalletUtilViews.removeSpinner(spinnerView)
        }
    }

    func showProcessing() {
        processingView = HyperwalletUtilViews.showProcessing()
    }

    func dismissProcessing(handler: @escaping () -> Void) {
        processingView?.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            handler()
        }
    }

    func showConfirmation(handler: @escaping (() -> Void)) {
        processingView?.hide(with: .complete)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            handler()
        }
    }

    func showTransferMethodFields(_ fieldGroups: [HyperwalletFieldGroup],
                                  _ transferMethodType: HyperwalletTransferMethodType) {
        addFieldsSection(fieldGroups)
        addInfoSection(transferMethodType)
        addCreateButtonSection()
        self.tableView.reloadData()
    }

    func showError( title: String, message: String) {
        HyperwalletUtilViews.showAlert(self, title: title, message: message, actions: UIAlertAction.close(self))
    }

    func showError(_ error: HyperwalletErrorType, _ handler: (() -> Void)?) {
        let errorView = ErrorView(viewController: self, error: error)
        errorView.show(handler)
    }

    func showBusinessError(_ error: HyperwalletErrorType, _ handler: @escaping (() -> Void)) {
        let errorView = ErrorView(viewController: self, error: error)
        errorView.businessError({ (_) in handler() })
    }

    func notifyTransferMethodAdded(_ transferMethod: HyperwalletTransferMethod) {
        DispatchQueue.global(qos: .background).async {
            NotificationCenter.default.post(name: .transferMethodAdded,
                                            object: self,
                                            userInfo: [UserInfo.transferMethod: transferMethod])
        }
        navigationController?
            .skipPreviousViewControllerIfPresent(skip: SelectTransferMethodTypeTableViewController.self)
        createTransferMethodHandler?(transferMethod)
    }

    private func focusOnInvalidField(_ widget: AbstractWidget) {
        if let indexPath = getIndexPathFor(fieldToBeFocused: widget) {
            if isCellVisibile(indexPath) {
                widget.focus()
            } else {
                let sectionContainingInvalidWidget = presenter.sectionData[indexPath.section]
                sectionContainingInvalidWidget.containsFocusedField = true
                presenter.prepareSectionForScrolling(sectionContainingInvalidWidget, indexPath.row, widget)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }

    private func getIndexPathFor(fieldToBeFocused: AbstractWidget) -> IndexPath? {
        if let sectionContainingInvalidField = presenter
            .sectionData
            .first(where: { $0.cells.contains(fieldToBeFocused) }),
            let sectionIndex = getSectionIndex(by: sectionContainingInvalidField.fieldGroup),
            let cellIndex = sectionContainingInvalidField.cells.firstIndex(of: fieldToBeFocused) {
            return IndexPath(row: cellIndex, section: sectionIndex)
        }
        return nil
    }

    private func updateFooterView(_ footerView: UITableViewHeaderFooterView, for section: Int) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        footerView.textLabel?.text = presenter.sectionData[section].errorMessage
        footerView.sizeToFit()
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }

    override public func tableView(_ tableView: UITableView,
                                   willDisplayFooterView view: UIView,
                                   forSection section: Int) {
        if let footerView = view as? UITableViewHeaderFooterView {
            footerView.textLabel?.textColor = Theme.Label.errorColor
        }
    }

    private func addFieldsSection(_ fieldGroups: [HyperwalletFieldGroup]) {
        for fieldGroup in fieldGroups {
            guard let fields = fieldGroup.fields, let fieldGroup = fieldGroup.group
                else {
                    continue
            }
            let newWidgets = fields.map(WidgetFactory.newWidget)
            let section = AddTransferMethodSectionData(
                fieldGroup: fieldGroup,
                country: country,
                currency: currency,
                cells: newWidgets
            )
            presenter.sectionData.append(section)
            widgets.append(contentsOf: newWidgets)
        }
    }

    private func addInfoSection(_ transferMethodType: HyperwalletTransferMethodType) {
        guard transferMethodType.fees != nil || transferMethodType.processingTime != nil else {
            return
        }

        if let infoLabel = infoView.arrangedSubviews[0] as? UILabel {
            infoLabel.attributedText = transferMethodType.formatFeesProcessingTime()
            let infoSection = AddTransferMethodSectionData(
                fieldGroup: "INFORMATION",
                country: country,
                currency: currency,
                cells: [infoView])
            presenter.sectionData.append(infoSection)
        }
    }

    private func addCreateButtonSection() {
        let buttonSection = AddTransferMethodSectionData(
            fieldGroup: "CREATE_BUTTON",
            country: country,
            currency: currency,
            cells: [createAccountButton])
        presenter.sectionData.append(buttonSection)
    }

    private func isCellVisibile(_ indexPath: IndexPath) -> Bool {
        let cellRect = tableView.rectForRow(at: indexPath)
        return tableView.bounds.contains(cellRect)
    }

    private func getIndexPath(for section: AddTransferMethodSectionData) -> IndexPath {
        let sectionIndex = getSectionIndex(by: section.fieldGroup)!
        return IndexPath(row: section.rowShouldBeScrolledTo!, section: sectionIndex)
    }
}

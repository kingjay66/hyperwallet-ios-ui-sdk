//
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

public final class ReceiptDetailTableViewController: UITableViewController {
    private let registeredCells: [(type: AnyClass, id: String)] = [
        (ReceiptTransactionTableViewCell.self, ReceiptTransactionTableViewCell.reuseIdentifier),
        (ReceiptFeeTableViewCell.self, ReceiptFeeTableViewCell.reuseIdentifier),
        (ReceiptDetailTableViewCell.self, ReceiptDetailTableViewCell.reuseIdentifier),
        (ReceiptNotesTableViewCell.self, ReceiptNotesTableViewCell.reuseIdentifier)
    ]

    private var presenter: ReceiptDetailViewPresenter!

    public init(with hyperwalletReceipt: HyperwalletReceipt) {
        super.init(nibName: nil, bundle: nil)
        presenter = ReceiptDetailViewPresenter(with: hyperwalletReceipt)
    }

    // swiftlint:disable unavailable_function
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "title_receipts_details".localized()
        titleDisplayMode(.never)
        setViewBackgroundColor()
        setupReceiptDetailTableView()
    }

    private func setupReceiptDetailTableView() {
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Theme.Cell.extraSmallHeight
        tableView.separatorStyle = .singleLine
        tableView.accessibilityIdentifier = "receiptDetailTableView"
        tableView.cellLayoutMarginsFollowReadableWidth = false
        registeredCells.forEach {
            tableView.register($0.type, forCellReuseIdentifier: $0.id)
        }
    }

    private func getCellConfiguration(_ indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = presenter.sectionData[indexPath.section].cellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let section = presenter.sectionData[indexPath.section]
        switch section.receiptDetailSectionHeader {
        case .transaction:
            if let tableViewCell = cell as? ReceiptTransactionTableViewCell,
                let transactionSection = section as? ReceiptDetailSectionTransactionData {
                tableViewCell.configure(transactionSection.tableViewCellConfiguration)
            }

        case .details:
            if let tableViewCell = cell as? ReceiptDetailTableViewCell,
                let detailSection = section as? ReceiptDetailSectionDetailData {
                let row = detailSection.rows[indexPath.row]
                tableViewCell.configure(row)
            }

        case .fee:
            if let tableViewCell = cell as? ReceiptFeeTableViewCell,
                let feeSection = section as? ReceiptDetailSectionFeeData {
                let row = feeSection.rows[indexPath.row]
                tableViewCell.configure(row)
           }

        case .notes:
            if let tableViewCell = cell as? ReceiptNotesTableViewCell,
                let notesSection = section as? ReceiptDetailSectionNotesData {
                tableViewCell.textLabel?.text = notesSection.notes
            }
        }
        return cell
    }
}

extension ReceiptDetailTableViewController {
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sectionData.count
    }

    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.sectionData[section].title
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.sectionData[section].rowCount
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCellConfiguration(indexPath)
    }

    override public func tableView(_ tableView: UITableView,
                                   estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Theme.Cell.headerHeight)
    }
}

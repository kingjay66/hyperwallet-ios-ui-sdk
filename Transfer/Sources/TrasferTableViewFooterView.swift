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

import UIKit

final class TrasferTableViewFooterView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "TrasferTableViewFooterViewIdentifier"

    lazy var footerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(footerLabel)
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        footerLabel.safeAreaCenterXAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor)
            .isActive = true
        footerLabel.safeAreaCenterYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
            .isActive = true
        footerLabel.safeAreaLeadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
            .isActive = true
        footerLabel.safeAreaTrailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
            .isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

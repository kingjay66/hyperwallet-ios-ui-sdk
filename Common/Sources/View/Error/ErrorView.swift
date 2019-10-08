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
import Insights
import UIKit

/// The class to handle UI errors
public final class ErrorView {
    weak var viewController: UIViewController!
    var error: HyperwalletErrorType

    /// Initializer to initialize the class with errors to be displayed and the viewcontroller responsible
    /// to display the errors
    /// - Parameters:
    ///   - viewController: view controller that contains errors
    ///   - error: hyperwallet error
    public init(viewController: UIViewController, error: HyperwalletErrorType) {
        self.viewController = viewController
        self.error = error
    }

    /// To show error messages
    ///
    /// - Parameter handler: handler to either remain on same UI page or go back to previous
    public func show(_ handler: (() -> Void)?) {
        switch error.group {
        case .business:
            businessError()

        case .connection:
            connectionError({ (_) in handler?() })

        default:
            unexpectedError()
        }
    }

    /// To handle business errors
    ///
    /// - Parameter handler: to handle business error
    public func businessError(_ handler: ((UIAlertAction) -> Void)? = nil) {
        if let hyperwalletErrors = error.getHyperwalletErrors()?.errorList {
            DispatchQueue.global().async {
                for hyperwalletError in hyperwalletErrors {
                    let pageInfo = PageInfo(pageName: "\(self.viewController)",
                                            pageGroup: "Error",
                                            sdkVersion: HyperwalletBundle.currentSDKAppVersion ?? "",
                                            rosettaLanguage: "en")
                    let errorInfo = ErrorInfo(type: EventConstants.errorTypeApi,
                                              message: hyperwalletError.code,
                                              fieldName: hyperwalletError.fieldName ?? "",
                                              description: Thread.callStackSymbols.joined(separator: "\n"),
                                              code: hyperwalletError.code)
                    
                    Insights.shared.trackError(pageInfo: pageInfo, errorInfo: errorInfo)
                }
            }
        }
        HyperwalletUtilViews.showAlert(viewController,
                                       title: "error".localized(),
                                       message: error.getHyperwalletErrors()?.errorList?
                                                .filter { $0.fieldName == nil }
                                                .map { $0.message }
                                                .joined(separator: "\n"),
                                       actions: UIAlertAction.close(handler))
    }

    private func unexpectedError() {
        let pageInfo = PageInfo(pageName: "\(self.viewController)",
                                pageGroup: "Error",
                                sdkVersion: HyperwalletBundle.currentSDKAppVersion ?? "",
                                rosettaLanguage: "en")
        let errorInfo = ErrorInfo(type: EventConstants.errorTypeException,
                                  message: error.errorDescription ?? "",
                                  fieldName: "",
                                  description: Thread.callStackSymbols.joined(separator: "\n"),
                                  code: error.getHyperwalletErrors()?.errorList?.first?.code ?? "")
        Insights.shared.trackError(pageInfo: pageInfo, errorInfo: errorInfo)
        HyperwalletUtilViews.showAlert(viewController,
                                       title: "unexpected_title".localized(),
                                       message: "unexpected_error_message".localized(),
                                       actions: UIAlertAction.close(viewController))
    }

    private func connectionError(_ handler: @escaping (UIAlertAction) -> Void) {
        let pageInfo = PageInfo(pageName: "\(self.viewController)",
                                pageGroup: "Error",
                                sdkVersion: HyperwalletBundle.currentSDKAppVersion ?? "",
                                rosettaLanguage: "en")
        let errorInfo = ErrorInfo(type: EventConstants.errorTypeConnection,
                                  message: error.errorDescription ?? "",
                                  fieldName: "",
                                  description: Thread.callStackSymbols.joined(separator: "\n"),
                                  code: error.getHyperwalletErrors()?.errorList?.first?.code ?? "")
        Insights.shared.trackError(pageInfo: pageInfo, errorInfo: errorInfo)
        HyperwalletUtilViews.showAlertWithRetry(viewController,
                                                title: "network_connection_error_title".localized(),
                                                message: "network_connection_error_message".localized(),
                                                handler)
    }
}

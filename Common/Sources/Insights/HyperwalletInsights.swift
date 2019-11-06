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

import Foundation
import HyperwalletSDK
import Insights

public protocol HyperwalletInsightsProtocol: class {
    func trackClick(pageName: String, pageGroup: String, link: String, params: [String: String])

    func trackImpression(pageName: String, pageGroup: String, params: [String: String])

    func trackError(pageName: String, pageGroup: String)
}
/// Class responsible for initializing the Insights module.
/// It contains methods to call Insights for various actions performed by the user
public class HyperwalletInsights: HyperwalletInsightsProtocol {
    private static var instance: HyperwalletInsights?

    /// Returns the previously initialized instance of the HyperwalletInsights interface object
    public static var shared: HyperwalletInsights {
        return instance ?? HyperwalletInsights()
    }

    private init() {
        loadConfiguration { configuration in
            if let configuration = configuration {
                self.initializeInsights(configuration: configuration)
            }
        }
    }

    /// Set up HyperwalletInsights
    ///
    /// - Parameter configuration: Retrieved configuration object from SDK
    public static func setup() {
        instance = HyperwalletInsights()
    }

    /// Track Clicks
    ///
    /// - Parameters:
    ///   - pageName: Name of the page
    ///   - pageGroup: Page group name
    ///   - link: The link clicked - example : select-transfer-method
    ///   - params: A list of other information to be tracked - example : country,currency
    public func trackClick(pageName: String, pageGroup: String, link: String, params: [String: String]) {
        if let insights = Insights.shared {
            insights.trackClick(pageName: pageName, pageGroup: pageGroup, link: link, params: params)
        } else {
            HyperwalletInsights.shared.loadConfiguration { configuration in
                if let configuration = configuration {
                    HyperwalletInsights.shared.initializeInsights(configuration: configuration)
                    Insights.shared?.trackClick(pageName: pageName, pageGroup: pageGroup, link: link, params: params)
                }
            }
        }
    }

    /// Track Error
    ///
    /// - Parameters:
    ///   - pageName: Name of the page - example : transfer-method:add:select-transfer-method
    ///   - pageGroup: Page group name - example : transfer-method
    public func trackError(pageName: String, pageGroup: String) {
    }

    /// Track Impressions
    ///
    /// - Parameters:
    ///   - pageName: Name of the page - example : transfer-method:add:select-transfer-method
    ///   - pageGroup: Page group name - example : transfer-method
    ///   - params: A list of other information to be tracked - example : country,currency
    public func trackImpression(pageName: String, pageGroup: String, params: [String: String]) {
        if let insights = Insights.shared {
            insights.trackImpression(pageName: pageName, pageGroup: pageGroup, params: params)
        } else {
            HyperwalletInsights.shared.loadConfiguration { configuration in
                if let configuration = configuration {
                    HyperwalletInsights.shared.initializeInsights(configuration: configuration)
                    Insights.shared?.trackImpression(pageName: pageName, pageGroup: pageGroup, params: params)
                }
            }
        }
    }

    /// Checks if the configurations have already been fetched - returns immediately if true
    /// Else, try to fetch configuration and return the 
    ///
    /// - Parameter completion: boolean completion handler
    private func loadConfiguration(completion: @escaping(Configuration?) -> Void) {
        // Fetch configuration again
        Hyperwallet.shared.getConfiguration { configuration, _ in
            if let configuration = configuration {
                completion(configuration)
            } else {
                completion(nil)
            }
        }
    }

    /// Initialize the Insights module if the url and environment variables are available
    private func initializeInsights(configuration: Configuration) {
        if let environment = configuration.environment,
            let insightsUrl = configuration.insightsUrl {
            Insights.setup(environment: environment,
                           programToken: configuration.issuer,
                           sdkVersion: HyperwalletBundle.currentSDKAppVersion ?? "",
                           apiUrl: insightsUrl,
                           userToken: configuration.userToken)
        }
    }
}
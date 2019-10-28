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
import Insights
import HyperwalletSDK

public class HyperwalletInsights {
    private static var instance: HyperwalletInsights?
    public static var shared: HyperwalletInsights {
        return instance ?? HyperwalletInsights()
    }

    private func initializeInsights(completion: @escaping (Bool) -> Void ) {
        Hyperwallet.getConfiguration { configuration, error in
            if let configuration = configuration,
                let environment = configuration.environment,
                let insightsUrl = configuration.insightsUrl {
                Insights.setup(environment: environment,
                               programToken: configuration.issuer,
                               sdkVersion: HyperwalletBundle.currentSDKAppVersion ?? "",
                               url: insightsUrl,
                               userToken: configuration.userToken)
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    public func trackClick(pageName: String, pageGroup: String, link: String, params: [String: String]) {
        DispatchQueue.global().async {
            if Insights.shared == nil {
                self.initializeInsights { result in
                    if result {
                        Insights.shared?.trackClick(pageName: pageName, pageGroup: pageGroup, link: link, clickParams: params)
                    }
                }
            } else {
                Insights.shared?.trackClick(pageName: pageName, pageGroup: pageGroup, link: link, clickParams: params)
            }
        }
    }
}

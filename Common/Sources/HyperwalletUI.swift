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

#if !COCOAPODS
import UserRepository
#endif
import HyperwalletSDK
import Insights

@objc
public enum HyperwalletUIError: Int, Error {
    case notInitialized
}

/// Class responsible for initializing the Hyperwallet UI SDK. It contains methods to interact with the controllers
/// used to interact with the Hyperwallet platform
@objcMembers
public final class HyperwalletUI: NSObject {
    private static var instance: HyperwalletUI?
    public private(set) var userToken: String?

    /// Returns the previously initialized instance of the Hyperwallet UI SDK interface object
    public static var shared: HyperwalletUI {
        guard let instance = instance else {
//            fatalError("Call HyperwalletUI.setup(_:) before accessing HyperwalletUI.shared")
            let exception = NSException(name: NSExceptionName(rawValue: "arbitrary"), reason: "arbitrary reason", userInfo: nil)
            exception.raise()
            fatalError("Call HyperwalletUI.setup(_:) before accessing HyperwalletUI.shared")
        }
        return instance
    }

    /// Creates a new instance of the Hyperwallet UI SDK interface object. If a previously created instance exists,
    /// it will be replaced.
    ///
    /// - Parameter provider: a provider of Hyperwallet authentication tokens.
    public class func setup(_ provider: HyperwalletAuthenticationTokenProvider,
                            completion: @escaping (HyperwalletUIError?) -> Void) {
        instance = HyperwalletUI(provider, completion: { _ in
            HyperwalletUI.clearInstance()
            completion(HyperwalletUIError.notInitialized)
        })
    }

    static func clearInstance() {
        instance = nil
    }

    private init(_ provider: HyperwalletAuthenticationTokenProvider,
                 completion: @escaping (Error?) -> Void) {
        super.init()
        Hyperwallet.setup(provider) { [weak self] configuration, error in
            guard let strongSelf = self else {
                return
            }
            if let configuration = configuration {
                strongSelf.userToken = configuration.userToken
                if let userToken = strongSelf.userToken {
                    Insights.setup(environment: "dev",
                                   programToken: configuration.issuer,
                                   sdkVersion: HyperwalletBundle.currentSDKAppVersion ?? "",
                                   url: "url",
                                   userToken: userToken)
                }
            } else {
                completion(error)
            }
        }
//        UserRepositoryFactory.shared.userRepository().getUser {  [weak self] result in
//            guard let strongSelf = self else {
//                return
//            }
//            switch result {
//            case .failure(let error):
//                print("error fetching user: \(error)")
//                completion(error)
//
//            case .success(let user):
//                strongSelf.userToken = user?.token
//                if let userToken = strongSelf.userToken {
//                    Insights.setup(apiUrl: "https://api.paypal.com", userToken: userToken, programToken: programToken)
//                }
//            }
//        }
    }
}

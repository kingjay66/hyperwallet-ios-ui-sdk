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

class FPTITagsPayloadGenerator {
    private static var instance: FPTITagsPayloadGenerator?

    /// Returns the previously initialized instance of the FPTITagsPayloadGenerator
    static var shared: FPTITagsPayloadGenerator {
        if instance == nil {
            instance = FPTITagsPayloadGenerator()
        }
        return instance!
    }

    // Event params that will be auto populated while building the FPTI Event.
    private(set) var eventParamsDictionary = [String: Any]()

    private init() {
        eventParamsDictionary[FPTITag.mobileDeviceModel] = FPTITagsPayloadGenerator.mobileDeviceModel
        eventParamsDictionary[FPTITag.deviceType] = FPTITagsPayloadGenerator.deviceType
        eventParamsDictionary[FPTITag.sdkVersion] = FPTITagsPayloadGenerator.currentSDKAppVersion
        eventParamsDictionary[FPTITag.product] = FPTITagValue.product
        eventParamsDictionary[FPTITag.operatingSystem] = FPTITagValue.operatingSystem
        eventParamsDictionary[FPTITag.operatingSystemVersion] = "\(FPTITagsPayloadGenerator.iosVersion)"
        eventParamsDictionary[FPTITag.pageTechnologyFramework] = FPTITagValue.swiftFramework
        eventParamsDictionary[FPTITag.deviceScreenHeight] = FPTITagsPayloadGenerator.deviceScreenHeight
        eventParamsDictionary[FPTITag.deviceScreenWidth] = FPTITagsPayloadGenerator.deviceScreenWidth
        eventParamsDictionary[FPTITag.component] = FPTITagValue.hyperwalletComponent
        eventParamsDictionary[FPTITag.timestamp] = Int64(Date().timeIntervalSince1970)
    }

    // Borrowed from Magnes. Screen Info
    private static let deviceScreenHeight: CGFloat  = {
        let screen = UIScreen.main
        let windowRect: CGRect = screen.nativeBounds
        return windowRect.height
    }()

    // Borrowed from Magnes. Screen Info
    private static let deviceScreenWidth: CGFloat  = {
        let screen = UIScreen.main
        let windowRect: CGRect = screen.nativeBounds
        return windowRect.width
    }()

    private static let deviceType: String? = {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone : return FPTITagValue.phoneDeviceTypeValue
        case .pad : return FPTITagValue.tabletDeviceTypeValue
        case .tv: return FPTITagValue.tvDeviceTypeValue
        case .carPlay: return FPTITagValue.carPlayDeviceTypeValue
        case .unspecified: return nil
        @unknown default:
            return nil
        }
    }()

    private static let mobileDeviceModel: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }()

    /// Gets the iOS System Version Property.
    private static let iosVersion: String = {
        let systemVersion = UIDevice.current.systemVersion
        return systemVersion
    }()

    private static let currentSDKAppVersion: String? = {
        let version: String? = HyperwalletBundle.bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        return version
    }()
}

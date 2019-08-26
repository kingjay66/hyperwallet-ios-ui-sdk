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
    var payload = [String: Any]()
    static let currentEpochSeconds = Int64(Date().timeIntervalSince1970)
    static let platform = UIDevice.current.systemName

    // Event params that will be auto populated while building the FPTI Event.
    var eventParamsDictionary: [String: Any] = [:]

    // Get the Operating System Major and minor version from Process Info.
    let processInfo = ProcessInfo()

    /// Builds a dictionary of event parameter for tracking. These event parameters are sent to fpti
    /// as a batch whenever required.
    func buildEvent() -> [String: Any] {
        // Build an fpti event and return it.

        // Set HTTP Params
        self.eventParamsDictionary[FPTITag.deviceTimeZone] = FPTITagsPayloadGenerator.currentTimeZone

        let timeInterval = NSDate().timeIntervalSince1970
        self.eventParamsDictionary[FPTITag.timestamp] = Int64(timeInterval * 1000)
        self.eventParamsDictionary[FPTITag.sdkVersion] = FPTITagsPayloadGenerator.currentSDKAppVersion
        self.eventParamsDictionary[FPTITag.operatingSystem] = "iOS"
        self.eventParamsDictionary[FPTITag.operatingSystemVersion] = "\(FPTITagsPayloadGenerator.iosVersion)"
        self.eventParamsDictionary[FPTITag.mobileDeviceModel] = FPTITagsPayloadGenerator.mobileDeviceModel

        // To Filter out Debug Events, we can use the Channel - Mobile-DEBUG as the criterea.
        self.eventParamsDictionary[FPTITag.deviceType] = FPTITagsPayloadGenerator.deviceType
        self.eventParamsDictionary[FPTITag.operatingSystem] = "iOS"
        self.eventParamsDictionary[FPTITag.deviceType] = FPTITagsPayloadGenerator.deviceIdentifier
        self.eventParamsDictionary[FPTITag.product] = FPTITagsPayloadGenerator.product
        self.eventParamsDictionary[FPTITag.pageTechnologyFramework] = FPTITag.swiftFramework

        // Screen Info
        self.eventParamsDictionary[FPTITag.deviceScreenHeight] = FPTITagsPayloadGenerator.deviceScreenHeight
        self.eventParamsDictionary[FPTITag.deviceScreenWidth] = FPTITagsPayloadGenerator.deviceScreenWidth
        return eventParamsDictionary
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

    /// Returns the device identifier as a string.
    public  static let deviceIdentifier: String? = {
        let uniqueIdentifier = UIDevice.current.identifierForVendor?.uuidString
        return uniqueIdentifier
    }()

    static let deviceType: String? = {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone : return FPTITag.phoneDeviceTypeValue
        case .pad : return FPTITag.tabletDeviceTypeValue
        case .tv: return FPTITag.tvDeviceTypeValue
        case .carPlay: return FPTITag.carPlayDeviceTypeValue
        case .unspecified: return nil
        @unknown default:
            return nil
        }
    }()

    public static let product: String? = {
        "hyperwallet-ui-sdk"
    }()

    static let mobileDeviceModel: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }()

    /// Gets the iOS System Version Property.
    static let iosVersion: String = {
        let systemVersion = UIDevice.current.systemVersion
        return systemVersion
    }()

    private static let currentTimeZone: Int?  = {
        NSTimeZone.system.secondsFromGMT() / 60
    }()

    static let currentSDKAppVersion: String? = {
        let version: String? = HyperwalletBundle.bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        return version
    }()

    func addParam(key: String, value: Any) {
        eventParamsDictionary[key] = value
    }
}

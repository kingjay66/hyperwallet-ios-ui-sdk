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

public struct FPTITag {
    public static let eventType = "e"
    public static let timestamp = "t"
    public static let pageName = "page"
    public static let pageGroup = "pgrp"
    public static let mobileDeviceModel = "mdvs"
    public static let pageTechnologyFramework = "pgtf"
    public static let ipAddress = "ip"
    public static let sessionId = "vid"
    public static let deviceType = "dvis"
    public static let product = "product"
    public static let deviceScreenWidth = "sw"
    public static let deviceScreenHeight = "sh"
    public static let operatingSystem = "os"
    public static let operatingSystemVersion = "osv"
    public static let sdkVersion = "sdk_version"
    //TODO language should be added from Accept-Language http header at server side
    public static let language = "rsta"
    // Component Hyperwallet
    public static let component = "comp"
    //UUID (unique per session)
    public static let trackingVisitId = "tracking_visit_id"
    //User Token
    public static let trackingVisitorId = "tracking_visitor_id"

    // Error Tags
    public static let errorFieldName = "erfd"
    public static let errorCode = "error_code"
    public static let errorMessage = "error_message"
    public static let errorType = "error_type"
    public static let errorDescription = "error_description"
}

public struct FPTITagValue {
    //Devide Type
    public static let phoneDeviceTypeValue = "Mobile Phone"
    public static let tabletDeviceTypeValue = "Tablet"
    public static let tvDeviceTypeValue = "TV"
    public static let carPlayDeviceTypeValue = "CarPlay"
    //Error Types
    public static let errorTypeApi = "API"
    public static let errorTypeForm = "FORM"
    public static let errorTypeConnection = "CONNECTION"
    public static let errorTypeException = "EXCEPTION"
    public static let errorCodeConnection = "TIMEOUT"

    public static let product = "mobile-ui-sdk"
    public static let operatingSystem = "iOS"
    public static let swiftFramework = "swift"
    public static let hyperwalletComponent = "hyperwallet"

    // Event Type
    public static let click = "cl"
    public static let impression = "im"
    public static let error = "er"
}

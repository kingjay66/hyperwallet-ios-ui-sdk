import XCTest

class BaseTests: XCTestCase {
    var app: XCUIApplication!
    var mockServer: HyperwalletMockWebServer!
    var spinner: XCUIElement!

    override func setUp() {
        continueAfterFailure = false

        mockServer = HyperwalletMockWebServer()
        mockServer.setUp()

        mockServer.setupStub(url: "/rest/v3/users/usr-token/authentication-token",
                             filename: "AuthenticationTokenResponse",
                             method: HTTPMethod.post)

        mockServer.setupStub(url: "/rest/v3/users/usr-token",
                             filename: "UserIndividualResponse",
                             method: HTTPMethod.get)
        // speed up UI
        UIApplication.shared.keyWindow?.layer.speed = 100
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        mockServer.tearDown()
    }
}

////
//// Copyright 2018 - Present Hyperwallet
////
//// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//// and associated documentation files (the "Software"), to deal in the Software without restriction,
//// including without limitation the rights to use, copy, modify, merge, publish, distribute,
//// sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
//// furnished to do so, subject to the following conditions:
////
//// The above copyright notice and this permission notice shall be included in all copies or
//// substantial portions of the Software.
////
//// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//import Foundation
//
//public class InMemoryFPTICacheController: NSObject {
//    public static let maxEventCacheSize = 50
//
//    private var events: [String: [String: Any]] = [String: [String: Any]]()
//}
//
//enum InMemoryCacheError: Error {
//    case memoryLimitExceeded
//}
//
//extension InMemoryFPTICacheController: FPTIEventsCache {
//    // Within in memory cache, we do not honor this.
//    func getAllEvents(limit: Int) throws -> EventsResponse? {
//        let eventsResponse = EventsResponse(eventParams: Array(events.values), eventKeys: Set(events.keys))
//        events.removeAll(keepingCapacity: true)
//        return eventsResponse
//    }
//
//    func getEventCount() -> Int {
//        return events.count
//    }
//
//    func saveEvent(eventParams: [String: Any], forSession: String) throws -> String? {
//        guard events.count < InMemoryFPTICacheController.maxEventCacheSize else {
//            print("Max Event Cache Size Exceeded. ")
//            throw InMemoryCacheError.memoryLimitExceeded
//        }
//        let eventId = UUID().uuidString
//        events[eventId] = eventParams
//        return eventId
//    }
//}

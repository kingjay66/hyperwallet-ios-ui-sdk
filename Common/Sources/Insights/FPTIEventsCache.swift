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

protocol FPTIEventsCache: class {
    /** This method gets events saved in our FPTI local datastore and returns the payload for all
     these events to the calling method. This method has to be called with a limit. We don't want
     a huge number of events to be sent to the server in case there is a pileup.

     Note that there may be events with more than one session id as well. This method generates a
     query that gets all the document ids stored in our datastore and fetches these documents from
     the couchbase index.
     create schema for sqlite
     sessionId - eventid - eventPayload.
     */
    func getAllEvents() throws -> EventsResponse?

    func getEventCount() -> Int

    /**
     Saves an FPTI Event Params within the Database. This saves the data in the Events table with a
     unique event id and a session id.
     */
    func saveEvent(eventParams: [String: Any], forSession: String)
    func updateStatusOfSentEvents()
    func deleteSentEvents(eventKeys: Set<String>)
}

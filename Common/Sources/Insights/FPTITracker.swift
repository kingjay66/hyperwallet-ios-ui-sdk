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

/// Standard tracking protocol that our default FPTI tracking implements.
public protocol FPTITrack {
    /// Track an FPTI Event of type `cl`.
    ///
    /// - Parameter params: Additional parameters to add to the event
    func trackClick(_ params: [String: Any])

    /// Track an FPTI Event of type `er`.
    ///
    /// - Parameter params: Additional parameters to add to the event
    func trackError(_ params: [String: Any])

    /// Track an FPTI Event of type `im`.
    ///
    /// - Parameter params: Additional parameters to add to the event
    func trackImpression(_ params: [String: Any])

    /// Flushes any saved events in the local database to the server.
    func flushData()
}

/// Represents an FPTI Tracker that is capable of tracking events sent to
/// This Tracker uses the FPTI Batch Tracking API to send data to the server.
/// To enable batching and ensuring persistance, we use a caching layer that keeps the cached data
/// on disk. This will be evicted as soon as the batch size reaches or the timer expires.
/// @note : FPTI (First Party Tracking Infrastructure)
public class FPTITracker: NSObject, FPTITrack {
    private static var instance: FPTITrack?

    /// Returns the previously initialized instance of the FPTITracker
    public static var shared: FPTITrack {
        if instance == nil {
            instance = FPTITracker()
        }
        return instance!
    }
    private var timerForFPTI: DispatchSourceTimer?
    private var sessionId: String
    /// Tracker Options defining some key parameters for tracker to operate.
    private var options = TrackerOptions()
    /// Dispatch Queue to send all tracker Events.
    private let eventDispatchQueue: DispatchQueue

    /// Get a shared reference to the Local Disk Cache. Internally, this is using
    /// Core Data to cache the events
    private var cacheController: FPTIEventsCache
    private lazy var flushInProgress = false

    /// Initializer for FPTI Tracker. Typically within an application, you want to have only one
    /// instance of the tracker. Upon initialization, this will also keep a check on existing events
    /// that are pending to be send to the server.
    override private init() {
        eventDispatchQueue = DispatchQueue(label: "com.hyperwallet.fpti", qos: .background)
        options = TrackerOptions()
        cacheController = FPTIEventCacheController.shared
        sessionId = UUID().uuidString
        super.init()
    }

    public func trackClick(_ params: [String: Any]) {
        trackEvent(FPTITagValue.click, with: params)
    }

    public func trackError(_ params: [String: Any]) {
        trackEvent(FPTITagValue.error, with: params)
    }

    public func trackImpression(_ params: [String: Any]) {
        trackEvent(FPTITagValue.impression, with: params)
    }

    private func trackEvent(_ eventType: String, with params: [String: Any]) {
        let eventParams = enrichLocalUserEvent(eventParams: params)
        eventDispatchQueue.async {
            self.cacheController.saveEvent(eventParams: eventParams)
            self.flushIfReachedMaxBatchSize()
            self.startFlushTimer()
        }
    }

    /// Flushes any saved events in the database to the server.
    public func flushData() {
        // If our application is already trying to flush events, we just quit the flush operation
        // and check on it later.
        guard !flushInProgress else {
            print("Flush is already in progress.")
            return
        }
        flushInProgress = true
        // Get all events in the database and make a batch network call.
        // Queue operations to get all sessions first and send those sessions once we have them
        eventDispatchQueue.async {
            let success = true
            let currentTime = Date().toMillis()!
            print("Fetching events from local cache before time \(currentTime). ")
            let events = self.cacheController.getAllEvents(before: currentTime)
            if events.isNotEmpty {
                print("Flushing events from local cache before time \(currentTime). ")
                // TODO make an api call to flush events to lighthouse
                // TODO in success of API call set timer to nil and purge sent events
                if success {
                    self.cacheController.deleteFlushedEvents(before: currentTime)
                    self.flushInProgress = false
                    self.timerForFPTI = nil
                    print("Flush Completed for events saved before \(currentTime)")
                }
            }
        }
    }

    private func enrichLocalUserEvent(eventParams: [String: Any]) -> [String: Any] {
        var eventParamsMutable: [String: Any] = eventParams
        eventParamsMutable[FPTITag.sessionId] = sessionId
        let autoGeneratedParams = FPTITagsPayloadGenerator.shared.eventParamsDictionary
        autoGeneratedParams.forEach { paramKey, paramValue in
            eventParamsMutable[paramKey] = paramValue
        }
        return eventParamsMutable
    }

    /// Starts a Tracker Timer for Firing events at regular events.
    /// If this is the first time a timer is initialized , then create a new timer event.
    /// Or work with the timer
    private func startFlushTimer() {
        // Initialize a timer
        initTimerWithTimeInterval(timeInterval: options.autoFlushTimerInterval)
    }

    private func flushIfReachedMaxBatchSize() {
        /// Once the event is saved in the database, do check if we have reached the max number of
        /// events that can be handled by the batch. try sending it over the network if that number
        /// has reached the @MAX_BATCH_SIZE
        if cacheController.getEventCount() >= options.maxBatchSize {
            print("Maximum batch size reached. Flushing data now. ")
            flushData()
        }
    }

    /// Initializes the timer associateSed with the FPTI Tracker. This timer will fire events to the
    /// Batch API at regular time intervals and send any data it has to the server.
    private func initTimerWithTimeInterval(timeInterval: TimeInterval) {
        timerForFPTI = DispatchSource.makeTimerSource(queue: eventDispatchQueue)
        guard let timerToFire = timerForFPTI else {
            return
        }
        timerToFire.setEventHandler {
            print("Triggering Auto Flush Timer.")
            self.flushData()
        }
        timerToFire.schedule(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(Int(timeInterval)),
                             repeating: timeInterval)
        timerToFire.resume()
    }
}

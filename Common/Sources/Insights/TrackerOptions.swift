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

/// Default options for Initiailzing the Tracker.
public protocol TrackerOptioning {
    /**
     Number of attempts to make to Automatically flush the data to FPTI servers. After this
     counter has reached, we stop trying to send automatically until the next event is tracked.
     @default 1
     */
    var maxFlushAttempts: Int { get set }

    /**
     Maximum Batch size after which we trigger a netowrk flush of events.
     @default 10
     */
    var maxBatchSize: Int { get set }

    /**
     Delay before purging active cached queue.
     @default 1.0
     */
    var bufferTimeToWaitBeforeFlush: Float { get set }

    /**
     How long should a session be kept alive if not currently active.
     @default 120 seconds (two minutes)
     */
    var keepSessionAliveInterval: TimeInterval { get set }

    /**
     An option to set the retry counts for network calls. If network dispatch fails
     for more than this value, we will not attempt to send this event again.
     @default 12
     */
    var retryCountsForEventDispatch: Int32 { get set }

    var networkDispatchTimeout: Double { get set }
}

/**
 Default TrackerOptions struct. Used in creating the FPTI Tracker module.
 */
public struct TrackerOptions: TrackerOptioning {
    /**
     A timer that will flush all the events to FPTI after a specified duration has expired.
     @default 10.0
     */
    public var autoFlushTimerInterval: Double = 10.0

    /**
     Number of attempts to make to Automatically flush the data to FPTI servers. After this
     counter has reached, we stop trying to send automatically until the next event is tracked.
     @default 1
     */
    public var maxFlushAttempts: Int = 1

    /**
     Maximum Batch size after which we trigger a netowrk flush of events.
     @default 10
     */
    public var maxBatchSize: Int = 10

    /**
     Delay before purging active cached queue.
     @default 1.0
     */
    public var bufferTimeToWaitBeforeFlush: Float = 1.0

    /**
     How long should a session be kept alive if not currently active.
     @default 120 seconds (two minutes)
     */
    public var keepSessionAliveInterval: TimeInterval = 120

    /**
     An option to set the retry counts for network calls. If network dispatch fails
     for more than this value, we will not attempt to send this event again.
     @default 12
     */
    public var retryCountsForEventDispatch: Int32 = 12

    public var networkDispatchTimeout: Double = 12.0
}

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

import CoreData
import Foundation

protocol FPTIEventsCache: class {
    /// This method gets events saved in our FPTI local database and returns the payload for all
    /// these events to the calling method.
    ///
    /// - Returns: [[String: Any]]
    func getAllEvents(before currentTime: Int64) -> [[String: Any]]

    /// This method returns number of events in the local database
    ///
    /// - Returns: Count of events in local database
    func getEventCount() -> Int

    /// Saves an FPTI Event Params within the Database. This saves the data in the Events table with a
    /// unique event id.
    func saveEvent(eventParams: [String: Any])

    /// Deletes sent events from local database
    func deleteFlushedEvents(before currentTime: Int64)

    /// Update retry column for events that were not flushed successfully
    func updateRetryForFailedFlushEvents(before currentTime: Int64)
}

class FPTIEventCacheController: FPTIEventsCache {
    private static var instance: FPTIEventsCache?
    private lazy var util = SerializationUtils()
    private let model = "HyperwalletUISDK"
    private lazy var persistentContainer: NSPersistentContainer = {
        let hyperwalletBundle = HyperwalletBundle.bundle
        let modelURL = hyperwalletBundle.url(forResource: self.model, withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        }
        return container
    }()

    /// Returns the previously initialized instance of the Hyperwallet UI SDK interface object
    static var shared: FPTIEventsCache {
        if instance == nil {
            instance = FPTIEventCacheController()
        }
        return instance!
    }

    private init() {
    }

    func getAllEvents(before currentTime: Int64) -> [[String: Any]] {
        var eventParamsArray: [[String: Any]] = []
        let context = persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Events> = Events.fetchRequest() //NSFetchRequest<Events>(entityName: "Events")
        let predicate = NSPredicate(format: "eventTimestamp < %@", currentTime)
        fetchRequest.predicate = predicate

        do {
            let events = try context.fetch(fetchRequest)

            for (index, event) in events.enumerated() {
                eventParamsArray.append(util.convertToDictionary(text: event.eventPayload!)!)
                print("Event \(index): \(event.eventTimestamp ) \(event.eventPayload ?? "N/A")")
            }
        } catch {
            print("❌ Failed to fetch events", error.localizedDescription)
        }
        return eventParamsArray
    }

    func getEventCount() -> Int {
        let context = persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Events> = Events.fetchRequest()

        do {
            let eventCount = try context.count(for: fetchRequest)
            return eventCount
        } catch {
            print("❌ Failed to fetch meme:", error.localizedDescription)
        }
        return 0
    }

    func saveEvent(eventParams: [String: Any]) {
        let context = persistentContainer.viewContext

        let event = Events(context: context) //NSEntityDescription.insertNewObject(forEntityName: "Events", into: context) as? Events
        let payloadString = util.convertToString(dict: eventParams)
//        if let event = event {
            event.eventPayload = payloadString
            event.eventTimestamp = Date().toMillis()
            do {
                try context.save()
                print("✅ Event saved successfully")
            } catch {
                print("❌ Failed to save Event: \(error.localizedDescription)")
            }
//        }
    }

    func deleteFlushedEvents(before currentTime: Int64) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Events.fetchRequest()
        let predicate = NSPredicate(format: "eventTimestamp < %@", currentTime as CVarArg)
        fetchRequest.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest( fetchRequest: fetchRequest)
        do {
            print("eventKeys to be before time \(currentTime)")
            try context.execute(deleteRequest)
            print("✅ Event deleted successfully before time \(currentTime)")
        } catch {
            print("❌ Failed to delete Event: \(error.localizedDescription)")
        }
    }

    func updateRetryForFailedFlushEvents(before currentTime: Int64) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Events> = Events.fetchRequest()
        let predicate = NSPredicate(format: "eventTimestamp < %@", currentTime as CVarArg)
//        let predicate = NSPredicate(format: "retry = %@", 1)
        fetchRequest.predicate = predicate
        do {
            print("eventKeys to be updated before time \(currentTime)")

            let events = try context.fetch(fetchRequest)
            for event in events {
                do {
                    try context.save()
                } catch {
                    print("Failed to update retry event")
                }
            }

            print("✅ Event updated successfully before time \(currentTime)")
        } catch {
            print("❌ Failed to update Event: \(error.localizedDescription)")
        }
    }
}

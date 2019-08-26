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

class FPTIEventCacheController: FPTIEventsCache {
    public static var shared: FPTIEventsCache = FPTIEventCacheController() as FPTIEventsCache
    private lazy var util = SerializationUtils()

    let model = "HyperwalletUISDK"
    lazy var persistentContainer: NSPersistentContainer = {
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
    func getAllEvents() throws -> EventsResponse? {
        var eventParamsArray: [[String: Any]] = []
        var documentIdKeys: Set<String> = []
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<Events>(entityName: "Events")

        do {
            let events = try context.fetch(fetchRequest)

            for (index, event) in events.enumerated() {
                documentIdKeys.insert(event.eventId!)
                eventParamsArray.append(util.convertToDictionary(text: event.eventPayload!)!)
                print("Event \(index): \(event.eventId ?? "N/A") \(event.eventTimestamp ?? Date()) \(event.eventPayload ?? "N/A")")
            }
        } catch let fetchErr {
            print("❌ Failed to fetch meme:", fetchErr)
            throw fetchErr
        }
        return EventsResponse(eventParams: eventParamsArray, eventKeys: documentIdKeys)
    }

    func getEventCount() -> Int {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<Events>(entityName: "Events")

        do {
            let eventCount = try context.count(for: fetchRequest)
            return eventCount
        } catch let fetchErr {
            print("❌ Failed to fetch meme:", fetchErr)
        }
        return 0
    }

    func saveEvent(eventParams: [String: Any], forSession: String) {
        let context = persistentContainer.viewContext
        let event = NSEntityDescription.insertNewObject(forEntityName: "Events", into: context) as? Events
        let payloadString = util.convertToString(dict: eventParams)
        if let event = event {
            event.eventId = UUID().uuidString as String
            event.eventPayload = payloadString
            event.eventTimestamp = Date()
            event.eventSession = forSession
            event.dispatchStatus = 0
            do {
                try event.validateForInsert()
                try context.save()
                print("✅ Event saved successfully")
            } catch {
                print("❌ Failed to save Event: \(error.localizedDescription)")
            }
        }
    }

    func updateStatusOfSentEvents() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Events>(entityName: "Events")
        // Add Predicate
        let predicate = NSPredicate(format: "dispatchStatus IN %@", "o")
        fetchRequest.predicate = predicate
    }

    func deleteSentEvents(eventKeys: Set<String>) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Events")
        let predicate = NSPredicate(format: "eventId IN %@", eventKeys)
        fetchRequest.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest( fetchRequest: fetchRequest)
        do {
            print("eventKeys to be deleted: \(eventKeys)")
            try context.execute(deleteRequest)
            print("✅ Event deleted successfully")
        } catch {
            print("❌ Failed to delete Event: \(error.localizedDescription)")
        }
    }
}

//
//  PersistenceService.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import Foundation
import CoreData

// MARK: - Persistence Service
final class PersistenceService {

    // MARK: - Static Properties
    static let shared = PersistenceService()

    // MARK: - Private Properties
    private let persistentContainer: NSPersistentContainer

    // MARK: - Initializer
    private init() {
        persistentContainer = NSPersistentContainer(name: "TripPlannerModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    // MARK: - Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Save Connections to Core Data
    func saveConnections(_ connections: [Connection]) {
        let context = self.context

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ConnectionEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to delete existing data: \(error)")
        }

        for connection in connections {
            let entity = ConnectionEntity(context: context)
            entity.from = connection.from
            entity.to = connection.to
            entity.price = connection.price
            entity.fromLat = connection.coordinates.from.lat
            entity.fromLong = connection.coordinates.from.long
            entity.toLat = connection.coordinates.to.lat
            entity.toLong = connection.coordinates.to.long
        }

        do {
            try context.save()
        } catch {
            print("Failed to save connections: \(error)")
        }
    }

    // MARK: - Fetch Connections from Core Data
    func fetchConnections() -> [Connection] {
        let fetchRequest: NSFetchRequest<ConnectionEntity> = ConnectionEntity.fetchRequest()

        do {
            let connectionEntities = try context.fetch(fetchRequest)
            return connectionEntities.map { entity in
                let fromLocation = Location(lat: entity.fromLat, long: entity.fromLong)
                let toLocation = Location(lat: entity.toLat, long: entity.toLong)
                let coordinates = Coordinates(from: fromLocation, to: toLocation)
                return Connection(from: entity.from ?? "", to: entity.to ?? "", coordinates: coordinates, price: entity.price)
            }
        } catch {
            print("Failed to fetch connections: \(error)")
            return []
        }
    }

    // MARK: - Save Context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

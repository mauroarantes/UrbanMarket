//
//  CoreDataManager.swift
//  Urban Market
//
//  Created by Mauro Arantes on 07/11/2023.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    var persistentCartProducts: [CartEntity] = []
    var persistentLikedProducts: [LikedEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "Urban_Market")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data: \(error.localizedDescription)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print("Error saving Core Data: \(error.localizedDescription)")
        }
    }
    
    func resetCoreData() {
        let fetchRequestLiked = NSFetchRequest<NSFetchRequestResult>(entityName: "LikedEntity")
        let deleteRequestLiked = NSBatchDeleteRequest(fetchRequest: fetchRequestLiked)
        let fetchRequestCart = NSFetchRequest<NSFetchRequestResult>(entityName: "CartEntity")
        let deleteRequestCart = NSBatchDeleteRequest(fetchRequest: fetchRequestCart)
        do {
            try container.viewContext.execute(deleteRequestLiked)
            try container.viewContext.execute(deleteRequestCart)
        } catch {
            print("Error reseting Core Data: \(error.localizedDescription)")
        }
        context.reset()
    }
}


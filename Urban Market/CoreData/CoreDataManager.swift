//
//  CoreDataManager.swift
//  Urban Market
//
//  Created by Mauro Arantes on 06/11/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    var persistentProfiles: [ProfileEntity] = []
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
    
    func getProfiles() {
        let request = NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
        do {
            persistentProfiles = try context.fetch(request)
        } catch let error {
            print("Error fetching Core Data: \(error.localizedDescription)")
        }
    }
    
    func addProfile(id: String) {
        getProfiles()
        if !persistentProfiles.contains(where: { profileEntity in
            profileEntity.id == id
        }) {
            let newProfile = ProfileEntity(context: context)
            newProfile.id = id
            save()
        }
    }
    
    func deleteProfile(id: String) {
        if let profile = persistentProfiles.first(where: { profileEntity in
            profileEntity.id == id
        }) {
            context.delete(profile)
            save()
        }
    }
    
    func resetManager() {
        
    }
}

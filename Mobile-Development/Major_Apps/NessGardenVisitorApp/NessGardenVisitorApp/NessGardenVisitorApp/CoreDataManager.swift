//
//  CoreDataManager.swift
//  NessGardenVisitorApp
//
//  Created by Kian Palas on 09/12/2025.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - core data stack
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "NessGardenVisitorApp")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving Core Data: \(error)")
            }
        }
    }
    
    // MARK: - overwrite cache
    
    func saveBeds(_ beds: [Bed]) {
        // 1. delete old data (so we don't get duplicates)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "BedEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try? context.execute(deleteRequest)
        
        // 2. save New Data
        for bed in beds {
            let entity = BedEntity(context: context)
            entity.bed_id = bed.bed_id // Maps struct 'bedid' to entity 'bed_id'
            entity.name = bed.name
            entity.latitude = bed.latitude
            entity.longitude = bed.longitude
        }
        
        saveContext()
        print("core data: saved \(beds.count) beds.")
    }
    
    // deletes all existing PlantEntities and saves the new list
    func savePlants(_ plants: [Plant]) {
        //  delete old
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PlantEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try? context.execute(deleteRequest)
        
        // 2. save new
        for plant in plants {
            let entity = PlantEntity(context: context)
            entity.recnum = plant.recnum
            entity.genus = plant.genus
            entity.species = plant.species
            entity.vernacular_name = plant.vernacular_name
            entity.bed = plant.bed
            entity.accsta = plant.accsta
            entity.latitude = plant.latitude
            entity.longitude = plant.longitude
        }
        
        saveContext()
        print("core data: saved \(plants.count) plants.")
    }
    
    // MARK: - Fetching Logic (Load from Cache)
    
    func fetchBeds() -> [Bed] {
        let fetchRequest: NSFetchRequest<BedEntity> = BedEntity.fetchRequest()
        
        do {
            let savedEntities = try context.fetch(fetchRequest)
            // convert Entities back to Structs
            let beds = savedEntities.map { entity in
                return Bed(
                    bed_id: entity.bed_id ?? "",
                    name: entity.name ?? "",
                    latitude: entity.latitude ?? "0.0",
                    longitude: entity.longitude ?? "0.0"
                )
            }
            return beds
        } catch {
            print("Error fetching beds: \(error)")
            return []
        }
    }
    
    func fetchPlants() -> [Plant] {
        let fetchRequest: NSFetchRequest<PlantEntity> = PlantEntity.fetchRequest()
        
        do {
            let savedEntities = try context.fetch(fetchRequest)
            // convert entities back to Structs
            let plants = savedEntities.map { entity in
                return Plant(
                    recnum: entity.recnum ?? "",
                    genus: entity.genus,
                    species: entity.species,
                    vernacular_name: entity.vernacular_name,
                    infraspecific_epithet: nil, // didn't cache this optional, set to nil
                    cultivar_name: nil,         // didn't cache this optional, set to nil
                    bed: entity.bed,
                    accsta: entity.accsta ?? "C",
                    latitude: entity.latitude,
                    longitude: entity.longitude,
                    country: nil,               // didn't cache
                    donor: nil                  // didn't cache
                )
            }
            return plants
        } catch {
            print("Error fetching plants: \(error)")
            return []
        }
    }
}

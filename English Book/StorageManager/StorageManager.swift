//
//  StorageManager.swift
//  English Book
//
//  Created by mac on 20.07.2022.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "English Book")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    func fetchData() -> [WordIKnow]? {
        let fetchRequest = WordIKnow.fetchRequest()
        
        do {
            let task = try context.fetch(fetchRequest)
            return task
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func save(title: String) -> WordIKnow? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "WordIKnow", in: context) else { return nil }
        guard let word = NSManagedObject(entity: entityDescription, insertInto: context) as? WordIKnow else { return nil }
        word.word = title
        saveContext()
        return word
    }
    
    
    func edit(_ word: WordIKnow, newName: String) {
        word.word = newName
        saveContext()
    }
    
    func delete(_ word: WordIKnow) {
        context.delete(word)
        saveContext()
    }
    
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
}

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
    
    func fetchWordsIKnow() -> [WordIKnow]? {
        let fetchRequest = WordIKnow.fetchRequest()
        
        do {
            let task = try context.fetch(fetchRequest)
            return task
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchLearnWords() -> [LearnWord]? {
        let fetchRequest = LearnWord.fetchRequest()

        do {
            let task = try context.fetch(fetchRequest)
            return task
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchDataBook() -> [BookCoreData]? {
        let fetchRequest = BookCoreData.fetchRequest()
        
        do {
            let task = try context.fetch(fetchRequest)
            return task
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    func appendIKnowWord(title: String) -> WordIKnow? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "WordIKnow", in: context) else { return nil }
        guard let word = NSManagedObject(entity: entityDescription, insertInto: context) as? WordIKnow else { return nil }
        word.word = title
        saveContext()
        return word
    }
    
    func appendLearnWord(title: String) -> LearnWord? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "LearnWord", in: context) else { return nil }
        guard let word = NSManagedObject(entity: entityDescription, insertInto: context) as? LearnWord else { return nil }
        word.word = title
        saveContext()
        return word
    }
    
    func saveBook(title: String, image: String, pages: [String]) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "BookCoreData", in: context) else { return  }
        guard let book = NSManagedObject(entity: entityDescription, insertInto: context) as? BookCoreData else { return  }
        book.title = title
        book.image = image
        
        var pagesNS: [PageCoreData] = []
        
        
        pages.forEach { page in
            guard let pageCoreData = StorageManager.shared.createTypePage() else { return }
            pageCoreData.page = page
            pagesNS.append(pageCoreData)
        }
        let setPagesNS = Set(pagesNS) as? NSSet
        
//        print(pagesNS.first?.page!)
        print("---------------------------------------------------------")
        guard let forPrint = setPagesNS?.allObjects.first as? PageCoreData else { return }
        print(forPrint.page!)
        
        book.page = setPagesNS
        saveContext()
        
    }
    
    
    
    func createTypePage() -> PageCoreData? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "PageCoreData", in: context)
        else { return nil}

        guard let pageCoreData = NSManagedObject(entity: entityDescription,
                                                insertInto: context) as? PageCoreData
        else { return nil}

        return pageCoreData
    }
    
    func delete(_ word: WordIKnow) {
        context.delete(word)
        saveContext()
    }
    
    func delete(_ word: LearnWord) {
        context.delete(word)
        saveContext()
    }
    
    func delete(_ book: BookCoreData) {
        context.delete(book)
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

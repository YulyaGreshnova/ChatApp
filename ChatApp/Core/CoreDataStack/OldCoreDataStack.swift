//
//  OldCoreDataStack.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 06.04.2022.
//

import Foundation
import CoreData

final class OldCoreDataStack: ICoreDataStack {
    
    static let shared = OldCoreDataStack()
    
    private init() {}
    
    private lazy var managedObjectModal: NSManagedObjectModel = {
        
        guard let moduleURL = Bundle.main.url(forResource: "ChatCoreDataModel", withExtension: "momd") else {
            return NSManagedObjectModel()
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: moduleURL) else {
            return NSManagedObjectModel()
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistenteStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModal)
        let fileManager = FileManager.default
        let storeName = "ChatCoreDataModel.sqlite"
        
        let documenDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistanceStoreURL = documenDirectoryURL.appendingPathComponent(storeName)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: persistanceStoreURL)
        } catch {
            print(error)
        }
        
        return coordinator
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistenteStoreCoordinator
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistenteStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
}

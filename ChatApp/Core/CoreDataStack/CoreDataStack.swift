//
//  CoreDataStack.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 06.04.2022.
//

import Foundation
import CoreData

final class CoreDataStack: ICoreDataStack {
    
    static let shared = CoreDataStack()
        
    private init() {}
    
    private lazy var container: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "ChatCoreDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            } else {
                ConsoleLogger.log(message: "\(storeDescription)")
            }
        }
        return container
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        return context
    }()
        
    lazy var mainContext: NSManagedObjectContext = {
       let context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
}

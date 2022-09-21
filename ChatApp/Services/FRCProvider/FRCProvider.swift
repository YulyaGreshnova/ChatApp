//
//  FRCConversationsProvider.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 16.04.2022.
//

import UIKit
import CoreData

protocol FRCProviderDelegate: AnyObject {
    func didChangeObjects(changes: [ObjectsChanges])
}

enum ObjectsChanges {
    case insert(IndexPath)
    case update(IndexPath)
    case delete(IndexPath)
    case move(at: IndexPath, to: IndexPath)
}

final class FRCProvider<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    private var objectsChanges: [ObjectsChanges] = []
    weak var delegate: FRCProviderDelegate?
    private let coreDataStack: ICoreDataStack
    private let fetchRequest: NSFetchRequest<T>
    private let cacheName: String?

    private lazy var fetchedResultsController: NSFetchedResultsController<T> = {
        let context = coreDataStack.mainContext
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: cacheName)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    init(coreDataStack: ICoreDataStack, fetchRequest: NSFetchRequest<T>, cacheName: String?) {
        self.coreDataStack = coreDataStack
        self.fetchRequest = fetchRequest
        self.cacheName = cacheName
        super.init()
        
        fetchObjects()
    }
    
    private func fetchObjects() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }

// MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectsChanges = []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { return }
            objectsChanges.append(.insert(indexPath))
        case .update:
            guard let indexPath = indexPath else { return }
            objectsChanges.append(.update(indexPath))
        case .delete:
            guard let indexPath = indexPath else { return }
            objectsChanges.append(.delete(indexPath))
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            objectsChanges.append(.move(at: indexPath, to: newIndexPath))
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didChangeObjects(changes: objectsChanges)
    }

    func numberOfObjects(section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func getObject(indexPath: IndexPath) -> T {
        return fetchedResultsController.object(at: indexPath)
    }
}

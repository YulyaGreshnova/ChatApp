//
//  ICoreDataStack.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 06.04.2022.
//

import Foundation
import CoreData

protocol ICoreDataStack {
   var backgroundContext: NSManagedObjectContext { get }
   var mainContext: NSManagedObjectContext { get }
}

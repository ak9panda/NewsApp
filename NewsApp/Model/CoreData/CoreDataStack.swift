//
//  CoreDataStack.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/28/21.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}
    
    var persistantContainer: NSPersistentContainer!
    
    var viewContext: NSManagedObjectContext {
        return persistantContainer.viewContext
    }
}

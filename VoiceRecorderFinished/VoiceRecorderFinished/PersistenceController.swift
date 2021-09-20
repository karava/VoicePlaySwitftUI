//
//  PersistenceController.swift
//  VoiceRecorderFinished
//
//  Created by Kishan Arava on 19/9/21.
//  Copyright © 2021 Andreas Schultz. All rights reserved.
//

import CoreData

struct PersistenceController {
    static let instance = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "VoiceRecorderFinished")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error while loading CoreData Stack: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                print("save correctly")
            } catch {
                print(error)
            }
        }
    }
}

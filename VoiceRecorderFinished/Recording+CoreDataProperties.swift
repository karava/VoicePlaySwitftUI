//
//  Recording+CoreDataProperties.swift
//  VoiceRecorderFinished
//
//  Created by Kishan Arava on 19/9/21.
//  Copyright © 2021 Andreas Schultz. All rights reserved.
//
//

import Foundation
import CoreData


extension Recording {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recording> {
        return NSFetchRequest<Recording>(entityName: "Recording")
    }

    @NSManaged public var fileURL: String
    @NSManaged public var createdAt: Date
    
    func getfileURL() -> URL {
        URL(string: fileURL)!
    }
}

extension Recording : Identifiable {

}

//
//  Recording+CoreDataProperties.swift
//  VoiceRecorderFinished
//
//  Created by Kishan Arava on 22/9/21.
//  Copyright © 2021 Andreas Schultz. All rights reserved.
//
//

import Foundation
import CoreData


extension Recording {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recording> {
        return NSFetchRequest<Recording>(entityName: "Recording")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var fileName: String
    @NSManaged public var recordingParts: NSSet?
    
    var fileURL: URL {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilePath = documentPath.appendingPathComponent(fileName + ".m4a")
        
        return audioFilePath
    }
}

// MARK: Generated accessors for recordingParts
extension Recording {

    @objc(addRecordingPartsObject:)
    @NSManaged public func addToRecordingParts(_ value: RecordingPart)

    @objc(removeRecordingPartsObject:)
    @NSManaged public func removeFromRecordingParts(_ value: RecordingPart)

    @objc(addRecordingParts:)
    @NSManaged public func addToRecordingParts(_ values: NSSet)

    @objc(removeRecordingParts:)
    @NSManaged public func removeFromRecordingParts(_ values: NSSet)

}

extension Recording : Identifiable {

}

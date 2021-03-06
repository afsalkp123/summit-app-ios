//
//  NotificationManagedObject.swift
//  OpenStack Summit
//
//  Created by Alsey Coleman Miller on 1/27/17.
//  Copyright © 2017 OpenStack. All rights reserved.
//

import Foundation
import CoreData
import Foundation

public final class NotificationManagedObject: Entity {
    
    @NSManaged public var created: Date
    
    @NSManaged public var body: String
    
    @NSManaged public var from: String
    
    @NSManaged public var channel: String
    
    @NSManaged public var summit: SummitManagedObject
    
    @NSManaged public var event: EventManagedObject?
}

// MARK: - Encoding

extension Notification: CoreDataDecodable {
    
    public init(managedObject: NotificationManagedObject) {
        
        self.identifier = managedObject.id
        self.body = managedObject.body
        self.created = managedObject.created
        self.from = Topic(rawValue: managedObject.from)!
        self.channel = Channel(rawValue: managedObject.channel)!
        self.summit = managedObject.summit.id
        self.event = managedObject.event?.id
    }
}

extension Notification: CoreDataEncodable {
    
    public func save(_ context: NSManagedObjectContext) throws -> NotificationManagedObject {
        
        let managedObject = try cached(context)
        
        managedObject.created = created
        managedObject.body = body
        managedObject.from = from.rawValue
        managedObject.channel = channel.rawValue
        managedObject.summit = try context.relationshipFault(summit)
        managedObject.event = try context.relationshipFault(event)
        
        managedObject.didCache()
        
        return managedObject
    }
}

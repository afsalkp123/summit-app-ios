//
//  SummitDeserializer.swift
//  OpenStackSummit
//
//  Created by Claudio on 8/16/15.
//  Copyright © 2015 OpenStack. All rights reserved.
//
import UIKit
import SwiftyJSON

public class SummitDeserializer: NSObject, DeserializerProtocol {
    var deserializerStorage = DeserializerStorage()
    var deserializerFactory = DeserializerFactory()
    
    public func deserialize(json : JSON) -> BaseEntity {
        let summit = Summit()
        var deserializer : DeserializerProtocol!
        
        deserializer = deserializerFactory.create(DeserializerFactories.Company)
        for (_, companyJSON) in json["companies"] {
            deserializer.deserialize(companyJSON)
        }
        
        deserializer = deserializerFactory.create(DeserializerFactories.SummitType)
        var summitType : SummitType
        for (_, summitTypeJSON) in json["summitTypes"] {
            summitType = deserializer.deserialize(summitTypeJSON) as! SummitType
            summit.types.append(summitType)
        }
        
        deserializer = deserializerFactory.create(DeserializerFactories.EventType)
        for (_, eventTypeJSON) in json["eventTypes"] {
            deserializer.deserialize(eventTypeJSON)
        }
        
        deserializer = deserializerFactory.create(DeserializerFactories.PresentationCategory)
        for (_, presentationCategoryJSON) in json["presentationCategories"] {
            deserializer.deserialize(presentationCategoryJSON)
        }

        deserializer = deserializerFactory.create(DeserializerFactories.Venue)
        for (_, venueJSON) in json["locations"] {
            deserializer.deserialize(venueJSON)
        }
        
        var event : SummitEvent
        for (_, eventJSON) in json["events"] {

            deserializer = deserializerFactory.create(DeserializerFactories.SummitEvent)
            event = deserializer.deserialize(eventJSON) as! SummitEvent
            
            summit.events.append(event)
        }
        
        summit.name = json["name"].stringValue
        summit.id = json["id"].intValue
        return summit

    }
}

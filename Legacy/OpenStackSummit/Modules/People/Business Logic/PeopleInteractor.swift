//
//  PeopleInteractor.swift
//  OpenStackSummit
//
//  Created by Claudio on 10/5/15.
//  Copyright © 2015 OpenStack. All rights reserved.
//

import UIKit

@objc
public protocol IPeopleInteractor {
    func getSpeakersByFilter(saerchTerm: String?, page: Int, objectsPerPage: Int, completionBlock : ([PersonListItemDTO]?, NSError?) -> Void)
    func getAttendeesByFilter(saerchTerm: String?, page: Int, objectsPerPage: Int, completionBlock : ([PersonListItemDTO]?, NSError?) -> Void)
}

public class PeopleInteractor: NSObject, IPeopleInteractor {
    var presentationSpeakerDataStore: IPresentationSpeakerDataStore!
    var summitAttendeeRemoteDataStore: ISummitAttendeeRemoteDataStore!
    var personDTOAssembler: PersonListItemDTOAssembler!
    
    public func getSpeakersByFilter(searchTerm: String?, page: Int, objectsPerPage: Int, completionBlock : ([PersonListItemDTO]?, NSError?) -> Void) {
        let speakers = presentationSpeakerDataStore.getByFilterLocal(searchTerm, page: page, objectsPerPage: objectsPerPage)
        getByFilterCallback(speakers, error: nil, completionBlock: completionBlock)
    }
    
    public func getAttendeesByFilter(saerchTerm: String?, page: Int, objectsPerPage: Int, completionBlock : ([PersonListItemDTO]?, NSError?) -> Void) {
        summitAttendeeRemoteDataStore.getByFilter(saerchTerm, page: page, objectsPerPage: objectsPerPage) { (attendees, error) in
            self.getByFilterCallback(attendees, error: error, completionBlock: completionBlock)
        }
    }
    
    func getByFilterCallback<T: Person>(persons: [T]?, error: NSError?, completionBlock : ([PersonListItemDTO]?, NSError?) -> Void) {
        if (error != nil) {
            completionBlock(nil, error)
            return
        }
        
        var personListItemDTO: PersonListItemDTO
        var dtos: [PersonListItemDTO] = []
        for person in persons! {
            personListItemDTO = self.personDTOAssembler.createDTO(person)
            dtos.append(personListItemDTO)
        }
        
        completionBlock(dtos, error)
    }
}
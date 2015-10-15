//
//  MemberProfileInteractor.swift
//  OpenStackSummit
//
//  Created by Claudio on 9/2/15.
//  Copyright © 2015 OpenStack. All rights reserved.
//

import UIKit

@objc
public protocol IMemberProfileInteractor {
    func getSpeakerProfile(speakerId: Int, completionBlock : (PresentationSpeakerDTO?, NSError?) -> Void)
    func getAttendeeProfile(speakerId: Int, completionBlock : (SummitAttendeeDTO?, NSError?) -> Void)
    func isLoggedIn() -> Bool
}

public class MemberProfileInteractor: NSObject, IMemberProfileInteractor {
    
    var presentationSpeakerRemoteDataStore: IPresentationSpeakerRemoteDataStore!
    var summitAttendeeRemoteDataStore: ISummitAttendeeRemoteDataStore!
    var summitAttendeeDTOAssembler: ISummitAttendeeDTOAssembler!
    var presentationSpeakerDTOAssembler: IPresentationSpeakerDTOAssembler!
    var securityManager: SecurityManager!
    
    public func getSpeakerProfile(speakerId: Int, completionBlock : (PresentationSpeakerDTO?, NSError?) -> Void) {
        presentationSpeakerRemoteDataStore.getById(speakerId) { speaker, error in
            
            if (error != nil) {
                completionBlock(nil, error)
            }
            
            let speakerDTO = self.presentationSpeakerDTOAssembler.createDTO(speaker!)
            completionBlock(speakerDTO, error)
        }
    }
    
    public func getAttendeeProfile(attendeeId: Int, completionBlock : (SummitAttendeeDTO?, NSError?) -> Void) {
        summitAttendeeRemoteDataStore.getById(attendeeId) { attendee, error in
            
            if (error != nil) {
                completionBlock(nil, error)
            }
            
            let attendeeDTO = self.summitAttendeeDTOAssembler.createDTO(attendee!)
            completionBlock(attendeeDTO, error)
        }
    }
    
    public func isLoggedIn() -> Bool {
        return securityManager.isLoggedIn()
    }
}
//
//  EventsInterfaceController.swift
//  OpenStack Summit
//
//  Created by Alsey Coleman Miller on 9/1/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import WatchKit
import Foundation
import CoreSummit

final class EventsInterfaceController: WKInterfaceController {
    
    static let identifier = "Events"
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    // MARK: - Properties
    
    private(set) var events = [ScheduleItem]()
    
    // MARK: - Loading
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        events = (context as? Context<[ScheduleItem]>)?.value ?? ScheduleItem.from(realm: Store.shared.realm.objects(RealmSummitEvent))
        
        updateUI()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        /// set user activity
        if let summit = Store.shared.realm.objects(RealmSummit).first {
            
            updateUserActivity(AppActivity.screen.rawValue, userInfo: [AppActivityUserInfo.screen.rawValue: AppActivityScreen.events.rawValue], webpageURL: NSURL(string: summit.webpageURL + "/summit-schedule"))
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        invalidateUserActivity()
    }
    
    // MARK: - Private Methods
    
    private func updateUI() {
        
        // configure cells
        
        tableView.setNumberOfRows(events.count, withRowType: EventCellController.identifier)
        
        for (index, event) in events.enumerate() {
            
            let cell = tableView.rowControllerAtIndex(index) as! EventCellController
            let dateText = event.dateTime
            let locationText = event.location
            
            cell.nameLabel.setText(event.name)
            cell.dateLabel.setText(" " + dateText)
            cell.locationLabel.setText(locationText)
            cell.locationGroup.setHidden(locationText.isEmpty)
        }
    }
    
    // MARK: - Segue
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        let event = events[rowIndex]
        
        return Context(event.id)
    }
}

// MARK: - Supporting Types

final class EventCellController: NSObject {
    
    static let identifier = "EventCell"
    
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var locationLabel: WKInterfaceLabel!
    @IBOutlet weak var locationGroup: WKInterfaceGroup!
}

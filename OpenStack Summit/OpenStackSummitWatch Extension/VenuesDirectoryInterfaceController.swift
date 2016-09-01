//
//  VenuesDirectoryInterfaceController.swift
//  OpenStack Summit
//
//  Created by Alsey Coleman Miller on 9/1/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import WatchKit
import Foundation
import CoreSummit

final class VenuesDirectoryInterfaceController: WKInterfaceController {
    
    static let identifier = "VenuesDirectory"
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    // MARK: - Properties
    
    let locations = cachedSummit?.locations.map({ $0.rawValue }) ?? []
    
    // MARK: - Loading
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        updateUI()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: - Segue
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        let location = locations[rowIndex]
        
        return Context(location)
    }
    
    // MARK: - Private Methods
    
    private func updateUI() {
        
        tableView.setNumberOfRows(locations.count, withRowType: LabelCellController.identifier)
        
        for (index, location) in locations.enumerate() {
            
            let cell = tableView.rowControllerAtIndex(index) as! LabelCellController
            
            cell.textLabel.setText(location.name)
        }
    }
}
//
//  MainRevealViewController.swift
//  OpenStack Summit
//
//  Created by Alsey Coleman Miller on 5/8/17.
//  Copyright © 2017 OpenStack. All rights reserved.
//

import Foundation
import UIKit
import typealias CoreSummit.Identifier
import CoreSummit

final class MainRevealViewController: SWRevealViewController, SummitActivityHandlingViewController {
    
    // MARK: - Properties
    
    var menuViewController: MenuViewController { return rearViewController as! MenuViewController }
    
    // MARK: - Initialization
    
    init() {
        
        let menuViewController = R.storyboard.menu.menuViewController()!
        
        let frontViewController = UINavigationController(rootViewController: menuViewController.generalScheduleViewController)
        
        super.init(rearViewController: menuViewController, frontViewController: frontViewController)
        
        registerNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: - SummitActivityHandling
    
    func view(data: AppActivitySummitDataType, identifier: Identifier) {
        
        guard canView(data: data, identifier: identifier)
            else { return }
        
        // change to menu item section first
        switch data {
        case .event: menuViewController.showEvents()
        case .speaker: menuViewController.showSpeakers()
        case .venue, .venueRoom: menuViewController.showVenues()
        case .video: break
        }
        
        // show detail view controller
        frontViewController.show(data: data, identifier: identifier)
    }
    
    func view(screen: AppActivityScreen) {
        
        menuViewController.view(screen: screen)
    }
    
    func search(_ searchTerm: String) {
        
        menuViewController.search(searchTerm)
    }
    
    // MARK: - Notifications
    
    private func registerNotifications() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataWiping),
            name: Store.Notification.dataWiping,
            object: nil)
    }
    
    @objc private func dataWiping(_ notification: Foundation.Notification) {
        
        menuViewController.view(screen: .events)
        
        guard let topViewController = (frontViewController as? UINavigationController)?.topViewController as? ActivityViewController
            else { return }
        
        topViewController.showActivityIndicator(withMessage: "Updating...")
    }
}

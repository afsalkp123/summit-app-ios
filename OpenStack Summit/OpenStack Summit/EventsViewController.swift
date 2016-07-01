//
//  EventsViewController.swift
//  OpenStackSummit
//
//  Created by Gabriel Horacio Cutrini on 11/6/15.
//  Copyright © 2015 OpenStack. All rights reserved.
//

import XLPagerTabStrip
import KTCenterFlowLayout
import SwiftSpinner
import CoreSummit

final class EventsViewController: RevealTabStripViewController, ShowActivityIndicatorProtocol, MessageEnabledViewController {
    
    // MARK: - Properties
    
    private(set) var filterButton: UIBarButtonItem!
    
    var activeFilterIndicator = false {
        
        didSet {
            
            filterButton?.tintColor = activeFilterIndicator ? UIColor(hexaString: "#F8E71C") : UIColor.whiteColor()
            navigationController?.toolbar.barTintColor = UIColor(hexaString: "#F8E71C")
            navigationController?.toolbar.translucent = false
            navigationController?.setToolbarHidden(!activeFilterIndicator, animated: true)
        }
    }
    
    var scheduleFilter = ScheduleFilter() {
        
        didSet { activeFilterIndicator = scheduleFilter.hasActiveFilters() }
    }
    
    // MARK: - Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "EVENTS"
        
        filterButton = UIBarButtonItem()
        filterButton.target = self
        filterButton.action = #selector(EventsViewController.showFilters(_:))
        filterButton.image = UIImage(named: "filter")
        
        navigationItem.rightBarButtonItem = filterButton
        
        buttonBarView.collectionViewLayout = KTCenterFlowLayout()
        
        let message = UIBarButtonItem()
        message.title = "CLEAR ACTIVE FILTERS"
        message.style = .Plain
        message.target = self
        message.action = #selector(EventsViewController.clearFilters(_:))
        message.tintColor = UIColor(hexaString: "#4A4A4A")
        message.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15)], forState: .Normal)

        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: #selector(EventsViewController.clearFilters(_:)))
        
        let clear = UIBarButtonItem()
        clear.target = self
        clear.action = #selector(EventsViewController.clearFilters(_:))
        clear.image = UIImage(named: "cancel")
        clear.tintColor = UIColor.blackColor()
        
        toolbarItems = [message, spacer, clear]
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.toolbarHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func showFilters(sender: UIBarButtonItem) {
        
        guard Store.shared.realm.objects(RealmSummit).count > 0  else {
            
            showInfoMessage("Info", message: "No summit data available")
            return
        }
        
        //presenter.showFilters() push GeneralScheduleFilterViewController
    }
    
    @IBAction func clearFilters(sender: UIBarButtonItem) {
        
        scheduleFilter.clearActiveFilters()
        scheduleFilter.hasToRefreshSchedule = true
        self.activeFilterIndicator = false
        
        self.reloadPagerTabStripView()
    }
    
    // MARK: - RevealTabStripViewController
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        // FIXME: Add child VCs
        let trackListViewController = R.storyboard.tracks.trackListViewController()!
        
        /*
        childViewController.append(generalScheduleViewController)
        childViewController.append(trackListViewController)
        childViewController.append(levelListViewController)
        */
                
        return [trackListViewController]
    }
}
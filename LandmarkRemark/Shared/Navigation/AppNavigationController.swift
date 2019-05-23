//
//  AppNavigationController.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 21/05/19.
//  Copyright © 2019 mira. All rights reserved.
//

import UIKit

/**
    Controls the page flow between first-run intro screens and main map screen.
 
    It uses notification center to detect navigation events and switches the root view.
 */
class AppNavigationController: UINavigationController {
    
    let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        // listen for navigateToMap event notification
        notificationCenter.addObserver(self, selector: #selector(navigateToMap), name: NavigateToMap, object: nil)
    }
    
    /// Navigate to main screen flow by setting the map view as its root view. 
    @objc func navigateToMap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapVC = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        viewControllers[0] = mapVC
    }

    deinit {
        // Removes self from observer list
        notificationCenter.removeObserver(self)
    }
}

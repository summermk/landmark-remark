//
//  SplashViewController.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 20/05/19.
//  Copyright © 2019 mira. All rights reserved.
//

import UIKit

/// First landing screen which checks for initial setup
class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkIntroStateAndNavigate()
    }
    
    /**
        Checks whether the introduction setup has been completed.
     
        If the setup is not complete, it will show intro screens.
        Otherwise it navigates to map view which is the main flow.
    */
    func checkIntroStateAndNavigate() {
        
        let localStorage = LocalStore()
        
        // Check if the intro pages have been shown already.
        if !localStorage.didShowIntro {
            // show the intro pages
            performSegue(withIdentifier: "showIntro", sender: self)
            
        } else {
            // otherwise show the map
            NotificationCenter.default.post(name: NavigateToMap, object: nil)
        }
        
    }
    
    @IBAction func unwindToSplash(segue: UIStoryboardSegue) {
        // unwind from page controller. 
        // This is usually triggered after the setup is completed. 
        checkIntroStateAndNavigate()
    }

}

//
//  SetupPage.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 20/05/19.
//  Copyright © 2019 mira. All rights reserved.
//

import Foundation
import UIKit


class SetupPage: UIViewController {
    
    /// User name field
    @IBOutlet weak var usernameTextField: UITextField!
    
    /// Saves the user name when Go button is pressed
    @IBAction func goButtonPressed(_ sender: Any) {
        
        // check that user name is entered
        guard let username = usernameTextField.text, !username.isEmpty else {
            return
        }

        // save the username and first run flag in local storage 
        let localStorage = LocalStore()
        localStorage.username = username
        localStorage.didShowIntro = true
        
        // send notification that setup is complete
        NotificationCenter.default.post(name: SetupCompletedNotification, object: nil)
        
    }
}

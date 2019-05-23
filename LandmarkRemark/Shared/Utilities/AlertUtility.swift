//
//  AlertUtility.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 18/05/19.
//  Copyright © 2019 mira. All rights reserved.
//

import Foundation
import UIKit

class AlertUtility {
    
    /**
        Creates alert with the format of title, message and single CTA button
     */
    static func createAlert(title: String, message: String, defaultActionTitle: String) -> UIAlertController {
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: defaultActionTitle, style: .default, handler: nil)
        alert.addAction(defaultAction)
        
        return alert 
    }
}

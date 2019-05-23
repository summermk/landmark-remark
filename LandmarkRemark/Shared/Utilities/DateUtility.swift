//
//  DateUtility.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 19/05/19.
//  Copyright © 2019 mira. All rights reserved.
//

import Foundation

class DateUtility {
    
    /// Utility method to get the current date time in unix 
    static func currentDateTimeInUnix() -> Double {
        return Date().timeIntervalSince1970
    }
}

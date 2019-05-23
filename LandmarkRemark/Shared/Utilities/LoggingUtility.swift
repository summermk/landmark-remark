//
//  LoggingUtility.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 17/05/19.
//  Copyright © 2019 mira. All rights reserved.
//

import Foundation

/**
 * Logging for debugging and error logs.
 */
class LoggingUtility {
    static func debug(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}

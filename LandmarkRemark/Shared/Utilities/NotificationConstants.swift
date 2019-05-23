//
//  NotificationConstants.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 23/05/19.
//  Copyright © 2019 mira. All rights reserved.
//

import Foundation

// Constants of all app-wide notifications

/// Sent when first run setup is completed and user name is set.
let SetupCompletedNotification = Notification.Name("com.mira.LandmarkRemark.setupCompleted")

/// Sent when initial splash screen needs to transition to map.
let NavigateToMap = Notification.Name("com.mira.LandmarkRemark.navigateToMap")

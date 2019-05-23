//
//  LocalizableHelper.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 20/05/19.
//  Copyright © 2019 mira. All rights reserved.
//

import Foundation


/// Helper class to make it easier to call `NSLocalizedString`
class LocalizedString {

    /**
        Get the localised string using the key
     
        For available LocalizableKey types see `Alert`, `ScreenTitle` and `TextPlaceholder`.
        Actual strings can be found in Localizable.strings file.
     */
    static func get(_ key: LocalizableKey) -> String {
        return NSLocalizedString(key.value, comment: "")
    }
}

// Convert localizable string keys into enum cases
// to avoid typos and make it easier for code completion


protocol LocalizableKey {
    var value: String { get }
}

/// Strings used in Alert
enum Alert {
    enum Heading: String, LocalizableKey {
        case error = "ALERT_HEADING_ERROR"
        case locationDisabled = "ALERT_HEADING_LOCATION_DISABLED"
        
        var value: String {
            return rawValue
        }
    }
    
    enum Message: String, LocalizableKey {
        case addNoteError = "ALERT_MESSAGE_ADD_NOTE_ERROR"
        case noText = "ALERT_MESSAGE_NO_TEXT"
        case locationDisabled = "ALERT_MESSAGE_LOCATION_DISABLED"
        case noLocation = "ALERT_MESSAGE_NO_LOCATION"
        case noUsername = "ALERT_MESSAGE_NO_USERNAME"
        
        var value: String {
            return rawValue
        }
    }
    
    enum Action: String, LocalizableKey {
        case ok = "ALERT_ACTION_OK"
        
        var value: String {
            return rawValue
        }
    }
    
}

/// Strings used in titles
enum ScreenTitle: String, LocalizableKey {
    case add = "TITLE_ADD"
    case search = "TITLE_SEARCH"
    
    var value: String {
        return rawValue
    }
}

/// Strings used in text field placeholder
enum TextPlaceholder: String, LocalizableKey {
    case search = "TEXTFIELD_SEARCH_PLACEHOLDER"
    
    var value: String {
        return rawValue
    }
}

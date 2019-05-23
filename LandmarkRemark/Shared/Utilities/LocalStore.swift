//
//  LocalStore.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 20/05/19.
//  Copyright © 2019 mira. All rights reserved.
//

import Foundation

/// Simple local storage using UserDefaults.
/// This should only store non-sensitive information
class LocalStore {
    
    enum LocalStoreKey: String {
        case didShowIntro = "LR.didShowIntro"
        case username = "LR.username"
    }
    
    /// Flag to indicate whether intro setup is completed
    var didShowIntro: Bool {
        didSet {
            // save
            UserDefaults.standard.set(didShowIntro, forKey: LocalStoreKey.didShowIntro.rawValue)
        }
    }
    
    /// User name for the current user (no authentication is done)
    var username: String? {
        didSet {
            // save
            UserDefaults.standard.set(username, forKey: LocalStoreKey.username.rawValue)
        }
    }

    init() {
        // Initialize the values from local storage UserDefaults
        didShowIntro = UserDefaults.standard.bool(forKey: LocalStoreKey.didShowIntro.rawValue)
        username = UserDefaults.standard.string(forKey: LocalStoreKey.username.rawValue)
    }
    
    
}


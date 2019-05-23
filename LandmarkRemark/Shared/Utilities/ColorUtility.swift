//
//  ColorUtility.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 21/05/19.
//  Copyright © 2019 mira. All rights reserved.
//

import UIKit

/// Color Palette is used to get theme colours by name
struct ColorPalette {
    
    /*
     Theme Colors are added in the asset file but they are not supported in iOS 10.
     This is a workaround to manually set the colours.
     */
    
    var orange: UIColor {
        return orangeFromAsset ?? UIColor(red: 255/255, green: 130/255, blue: 70/255, alpha: 1.0)
    }
    
    var lightBlue: UIColor {
        return lightBlueFromAsset ?? UIColor(red: 190/255, green: 238/255, blue: 247/255, alpha: 1.0)
    }
    
    private var orangeFromAsset: UIColor? {
        if #available(iOS 11.0, *) {
            return UIColor(named: "highlightOrange")
        } else {
            return nil
        }
    }
    
    private var lightBlueFromAsset: UIColor? {
        if #available(iOS 11.0, *) {
            return UIColor(named: "lightBlue")
        } else {
            return nil
        }
    }
}

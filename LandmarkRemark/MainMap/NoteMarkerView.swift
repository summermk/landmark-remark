//
//  NoteMarkerView.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 19/05/19.
//  Copyright © 2019 mira. All rights reserved.
//

import Foundation
import MapKit


/**
 Custom view for map annotation marker.
 
 Note contents and user name is visible when map marker is tapped.
 */
@available(iOS 11.0, *)
class NoteMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let note = newValue as? NoteViewModel else {
                return
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            
            markerTintColor = note.markerTintColor
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = note.text
            detailCalloutAccessoryView = detailLabel
        }
    }
}

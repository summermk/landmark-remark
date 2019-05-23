//
//  MapPresenter.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 17/05/19.
//  Copyright (c) 2019 mira. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation
import MapKit

protocol MapPresentationLogic
{
    func presentLocationDisabledAlert()
    func presentCurrentLocation(_ location: CLLocation)
    func presentAddNoteWithNoLocationError()
    func presentAddNoteScreen()
    
    func presentNotes(_ notes:[NoteViewModel])
    func presentLocation(ofNote note: NoteViewModel)
}

class MapPresenter: MapPresentationLogic
{
    weak var viewController: MapDisplayLogic?

    // MARK: Constants
    
    // Alert strings
    private let alertTitle = LocalizedString.get(Alert.Heading.locationDisabled)
    private let alertMessage = LocalizedString.get(Alert.Message.locationDisabled)
    private let okActionTitle = LocalizedString.get(Alert.Action.ok)
    private let noLocationMessage = LocalizedString.get(Alert.Message.noLocation)
    
    
    // Map coordinate size
    private let coordinateDelta: CLLocationDegrees = 0.003
    
    // MARK: Presentation
    
    /// Initialize and format alert `UIAlertController` to display the message.
    func presentLocationDisabledAlert() {
        let alert = AlertUtility.createAlert(title: alertTitle, message: alertMessage, defaultActionTitle: okActionTitle)
        viewController?.displayAlert(alert)
    }
    
    /// Parse location object into region on the map
    func presentCurrentLocation(_ location: CLLocation) {
        let region = calculateRegion(fromLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        viewController?.displayRegionOnMap(region)
    }
    
    /// Parse the note location into region on the map
    func presentLocation(ofNote note: NoteViewModel) {
        let region = calculateRegion(fromLatitude: note.latitude, longitude: note.longitude)
        
        viewController?.displayRegionOnMap(region)
    }
    
    private func calculateRegion(fromLatitude latitude: Double, longitude: Double) -> MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: coordinateDelta, longitudeDelta: coordinateDelta)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    /// Error when attempting to add note without location.
    func presentAddNoteWithNoLocationError() {
        let alert = AlertUtility.createAlert(title: alertTitle, message: noLocationMessage, defaultActionTitle: okActionTitle)
        viewController?.displayAlert(alert)
    }
    
    /// Present notes list
    func presentNotes(_ notes: [NoteViewModel]) {
        viewController?.displayPins(notes)
    }
    
    /// Present add note screen
    func presentAddNoteScreen() {
        viewController?.goToAddNote()
    }
}
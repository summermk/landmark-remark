//
//  MapInteractor.swift
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
import MapKit

protocol MapBusinessLogic
{
    // Location related tasks
    func setupLocationManager()
    func startLocationUpdates()
    func stopLocationUpdates()
    
    // Notes related tasks
    func getNotes()
    func addNote()
    func clearFocusOnNote()
}

protocol MapDataStore
{
    var longitude: Double? { get }
    var latitude: Double? { get }
    
    var noteToShow: NoteViewModel? { get set }
}

class MapInteractor: NSObject, MapBusinessLogic, MapDataStore
{
    // MARK: Clean swift components
    var presenter: MapPresentationLogic?
    var worker: NoteFetchWorker?
    
    // MARK: Location related properties
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var isUpdatingLocation = false      // true if location is updating
    var isStickingToLocation = false    // true if map is sticking to current location
    var locationError: Error?
    var locationPermissionNotGranted: Bool {
        let authStatus = CLLocationManager.authorizationStatus()
        return (authStatus == .denied || authStatus == .restricted)
    }

    var longitude: Double? {
        return location?.coordinate.longitude
    }
    
    var latitude: Double? {
        return location?.coordinate.latitude
    }
    
    var noteToShow: NoteViewModel? {
        didSet {
            // update
            if let note = noteToShow {
                // disable map sticking
                isStickingToLocation = false
                
                // show note location
                presenter?.presentLocation(ofNote: note)
            }
        }
    }
    
    func clearFocusOnNote() {
        noteToShow = nil
    }
    
    // MARK: - MapBusinessLogic
    
    /**
        Setup up the location manager by setting the delegate
        and desired accuracy.
     */
    func setupLocationManager() {
        // Accuracy is set to nearest 10 meters on the assumption
        // that landmarks are fairly large and doesn't need best accuracy.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    /**
        Start location updates with the accuracy of best.
     
        This method also asks for location permission and shows alert.
     */
    func startLocationUpdates() {
        // check the permission before attempting to get location
        requestLocationPermissionIfNeeded()
        
        // show error if permission is not granted
        guard !locationPermissionNotGranted else {
            presenter?.presentLocationDisabledAlert()
            return
        }
        
        // location service are not enabled
        if !CLLocationManager.locationServicesEnabled() {
            LoggingUtility.debug("Location services not enabled")
            presenter?.presentLocationDisabledAlert()
            return
        }
        
        // Setup up the location manager
        setupLocationManager()
        
        // Start updating location
        locationManager.startUpdatingLocation()
        isUpdatingLocation = true
        
        isStickingToLocation = (noteToShow == nil)  // only move the map if note is not showing
    }
    
    /**
        Stop location updates and set the location manager delegate to nil.
     */
    func stopLocationUpdates() {
        if !isUpdatingLocation {
            // early exit if location update is already stopped
            return
        }
        
        isUpdatingLocation = false
        isStickingToLocation = false
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil  // set delegate to nil to stop receiving updates
    }
    
    /**
        Request for location permission when the app is in use.
     
        It only asks for permission if the user hasn't responded yet.
     */
    private func requestLocationPermissionIfNeeded() {
        // request for location permission if it hasn't been asked yet
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
    }
    
    /**
        Get notes and display them on the map
     */
    func getNotes() {
        worker = NoteFetchWorker()
        
        worker?.readNotes(completion: { (notes) in
            guard let notes = notes else {
                // TODO: handle no notes
                // just don't show anything?
                return
            }
            
            // convert the notes dto to view model
            let viewModels = NoteConverter.convertDtosForMap(array: notes)
            // ask presenter
            self.presenter?.presentNotes(viewModels)
        })
    }
    
    /**
        Add a new note at current location.
     
        New note cannot be added without location.
     */
    func addNote() {
        if hasValidLocation() {
            presenter?.presentAddNoteScreen()
        } else {
            presenter?.presentLocationDisabledAlert()
        }
    }
    
    /**
        Checks if valid location data has been updated, or if
     */
    func hasValidLocation() -> Bool {
        return location != nil
    }
}

// MARK: - CLLocationManagerDelegate
extension MapInteractor: CLLocationManagerDelegate {
    
    // Implementation for when new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        LoggingUtility.debug("didUpdateLocations: \(newLocation)")
        
        guard validate(location: newLocation) else {
            // ignore invalid location
            return
        }

        
        location = newLocation
        locationError = nil
        
        
        if isStickingToLocation {
            // check if there is note showing
            if noteToShow != nil {
                // don't move the map
                isStickingToLocation = false
                return
            }
            
            // present the updated location
            presenter?.presentCurrentLocation(newLocation)
            
            // unstick after updating the map once
            // otherwise the map keeps dragging back to the current location
            isStickingToLocation = false
        }
        
    }
    
    /**
        validate the location and return true if valid.
     */
    private func validate(location: CLLocation) -> Bool {
        // ignore the cached result
        if location.timestamp.timeIntervalSinceNow < -5 {
            return false
        }
        
        // value less than 0 is invalid.
        // ignore the invalid measurements
        if location.horizontalAccuracy < 0 {
            return false
        }
        
        // otherwise it's valid
        return true
    }
    
    
    // Implementation for handling the error from location manager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        LoggingUtility.debug("didFailWithError: \(error.localizedDescription)")
        
        // Ignore the unknown location error as it will be recovered automatically
        // or change to more serious error code
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        
        locationError = error
        stopLocationUpdates()
    }
}
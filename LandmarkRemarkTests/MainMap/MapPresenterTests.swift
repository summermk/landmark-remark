//
//  MapPresenterTests.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 17/05/19.
//  Copyright (c) 2019 mira. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import LandmarkRemark
import XCTest
import MapKit

class MapPresenterTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: MapPresenter!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupMapPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupMapPresenter()
  {
    sut = MapPresenter()
  }
  
  // MARK: Test doubles
  
  class MapDisplayLogicSpy: MapDisplayLogic
  {
    
    var displayAlertCalled = false
    var displayRegionOnMapCalled = false
    var displayPinsCalled = false
    var goToAddNoteCalled = false
    
    func displayAlert(_ alert: UIAlertController) {
        displayAlertCalled = true
    }
    func displayRegionOnMap(_ region: MKCoordinateRegion) {
        displayRegionOnMapCalled = true
    }
    
    func displayPins(_ annotations: [NoteViewModel]) {
         displayPinsCalled = true
    }
    
    func goToAddNote() {
        goToAddNoteCalled = true
    }
  }
  
  // MARK: Tests
  
  func testPresentLocationDisabledAlert()
  {
    // Given
    let spy = MapDisplayLogicSpy()
    sut.viewController = spy
    
    // When
    sut.presentLocationDisabledAlert()
    
    // Then
    XCTAssertTrue(spy.displayAlertCalled, "presentSomething(response:) should ask the view controller to display the result")
  }
}

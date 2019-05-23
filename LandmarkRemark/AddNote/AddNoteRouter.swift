//
//  AddNoteRouter.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 18/05/19.
//  Copyright (c) 2019 mira. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol AddNoteRoutingLogic
{
}

protocol AddNoteDataPassing
{
  var dataStore: AddNoteDataStore? { get }
}

class AddNoteRouter: NSObject, AddNoteRoutingLogic, AddNoteDataPassing
{
  weak var viewController: AddNoteViewController?
  var dataStore: AddNoteDataStore?
  
}
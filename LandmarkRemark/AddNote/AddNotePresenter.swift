//
//  AddNotePresenter.swift
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

enum AddNotePresentationError {
    case noText
    case noLocation
    case noUsername
    case error(Error)
}

protocol AddNotePresentationLogic
{
    func presentError(withType: AddNotePresentationError)
    func presentSuccess()
}

class AddNotePresenter: AddNotePresentationLogic
{
    weak var viewController: AddNoteDisplayLogic?
    
    /**
        Present error for various cases as listed in `AddNotePresentationError`
     */
    func presentError(withType errorType: AddNotePresentationError) {
        let title = LocalizedString.get(Alert.Heading.error)
        var message = LocalizedString.get(Alert.Message.addNoteError)
        let action = LocalizedString.get(Alert.Action.ok)
        
        switch errorType {
        case .noText:
            message = LocalizedString.get(Alert.Message.noText)
            
        case .noLocation:
            message = LocalizedString.get(Alert.Message.noLocation)
            
        case .noUsername:
            message = LocalizedString.get(Alert.Message.noUsername)
            
        case .error(let underlyingError):
            message = underlyingError.localizedDescription
        }
        
        let alert = AlertUtility.createAlert(title: title, message: message, defaultActionTitle: action)
        viewController?.displayAlert(alert)
    }
    
    /**
        Present success which is just closing the view
     */
    func presentSuccess() {
        viewController?.closeView()
    }
}

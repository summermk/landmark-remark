//
//  AddNoteWorker.swift
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
import Firebase

protocol AddNoteWorkerProtocol {
    func addNewNote(_ note: Note.Dto, completion: @escaping (Error?) -> Void) 
}

class AddNoteWorker: AddNoteWorkerProtocol
{

    // MARK: Firestore related properties
    lazy var db = {
        return Firestore.firestore()
    }()
    
    // collectionPath used in Firestore
    let noteCollectionPath = "notes"
    
    /**
     Save the new note in Firestore.
     
     - Parameter note: DTO for note model
     - Parameter completion: Completion closure with optional error
     */
    func addNewNote(_ note: Note.Dto, completion: @escaping (Error?) -> Void) {
        // Parse the DTO object into dictionary
        // to prepare for firestore interaction
        var dictionary: [String: Any]
        do {
            dictionary = try note.asDictionary()
        } catch {
            completion(error)
            return
        }
        
        // Add a new document with a generated ID.
        // This ID is random and is not sequential.
        var ref: DocumentReference? = nil
        ref = db.collection(noteCollectionPath).addDocument(data: dictionary, completion: { (error) in
            completion(error)
            if let error = error {
                LoggingUtility.debug("Error adding document \(error)")
            } else {
                LoggingUtility.debug("Document added with ID: \(ref!.documentID)")
            }
        })
    }
    
}
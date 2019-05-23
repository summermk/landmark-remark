//
//  NoteConverter.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 19/05/19.
//  Copyright © 2019 mira. All rights reserved.
//

import Foundation

class NoteConverter {
    
    /// Converts the Note DTO into Note Display ViewModel
    static func convertDtoForMap(_ dto: Note.Dto) -> NoteViewModel {
        // convert the date time
        let actualDate = Date(timeIntervalSince1970: dto.datetime)
        
        return NoteViewModel(text: dto.text,
                           username: dto.username,
                           latitude: dto.latitude,
                           longitude: dto.longitude,
                           createdAt: actualDate)
    }
    
    /// Converts the array of Note DTOs into Note Display ViewModels 
    static func convertDtosForMap(array: [Note.Dto]) -> [NoteViewModel] {
        var viewModelArray = [NoteViewModel]()
        for element in array {
            let viewModel = convertDtoForMap(element)
            viewModelArray.append(viewModel)
        }
        
        return viewModelArray
    }
    
    
    /// Converts the Note DTO into Note Cell Model for table view
    static func convertDtoForTable(_ dto: Note.Dto) -> NoteCellModel {
        let actualDate = Date(timeIntervalSince1970: dto.datetime)
        return NoteCellModel(title: dto.text, subtitle: dto.username, latitude: dto.latitude, longitude: dto.longitude, createdAt: actualDate)
    }
    
    /// Converts the array of Note DTOs into Note Cell Model array
    static func convertDtosForTable(array: [Note.Dto]) -> [NoteCellModel] {
        var viewModelArray = [NoteCellModel]()
        for element in array {
            let viewModel = convertDtoForTable(element)
            viewModelArray.append(viewModel)
        }
        return viewModelArray
    }
    
    /// Converts the table cell model into Note View Model for map annotation
    static func convertCellForMap(_ cell: NoteCellModel) -> NoteViewModel {
        return NoteViewModel(text: cell.title, username: cell.subtitle, latitude: cell.latitude, longitude: cell.longitude, createdAt: cell.createdAt)
    }
    
}

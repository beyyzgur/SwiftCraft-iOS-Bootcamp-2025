//
//  SaveScreenViewModel.swift
//  Ticky
//
//  Created by beyyzgur on 24.04.2025.
//

import Foundation
class SaveScreenViewModel {
    var toDoRepository = ToDoRepository()
    
    func save(toDo_title: String) {
        toDoRepository.save(toDo_title: toDo_title)
    }
}

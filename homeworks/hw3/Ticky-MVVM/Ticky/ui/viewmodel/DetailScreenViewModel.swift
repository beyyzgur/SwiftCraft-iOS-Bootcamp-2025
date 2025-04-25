//
//  DetailScreenViewModel.swift
//  Ticky
//
//  Created by beyyzgur on 24.04.2025.
//

import Foundation
class DetailScreenViewModel {
    var toDoRepository = ToDoRepository()
    
    func update(toDo_id: Int,toDo_title: String) {
        toDoRepository.update(toDo_id: toDo_id,toDo_title: toDo_title)
    }
}

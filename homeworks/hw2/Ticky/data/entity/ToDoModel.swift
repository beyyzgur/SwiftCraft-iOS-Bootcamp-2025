//
//  ToDos.swift
//  Ticky
//
//  Created by beyyzgur on 19.04.2025.
//class değil struct olsaydı değişiklik yansıtamazdı.
class ToDoModel {
    
    var toDo_id : Int?
    var toDo_title : String?
    var isDone: Bool = false
    
    init () {}
    
    init(toDo_id: Int?, toDo_title: String?, isDone: Bool = false) {
        self.toDo_id = toDo_id
        self.toDo_title = toDo_title
        self.isDone = isDone
    }
}

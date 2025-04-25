//
//  MainScreenViewModel.swift
//  Ticky
//
//  Created by beyyzgur on 24.04.2025.
//

import Foundation
import RxSwift
class MainScreenViewModel {
    var toDoRepository = ToDoRepository()
    var toDosList = BehaviorSubject<[ToDoModel]>(value: [ToDoModel] ())
    
    init() {
        databaseCopy()
        toDosList = toDoRepository.toDosList // Bağlantıyı kurdum
    }
    
    func search(searchText: String) {
        toDoRepository.search(searchText: searchText)
    }
    
    func delete(toDo_id: Int) {
        toDoRepository.delete(toDo_id: toDo_id)
        fetchToDos()
    }
    
    func fetchToDos() {
        toDoRepository.fetchToDos()
    }
    
    func isTicked(toDo_id: Int) {
        toDoRepository.isTicked(toDo_id: toDo_id)
    }
    
    
    func databaseCopy() {
        let bandlePath = Bundle.main.path(forResource: "todo_app", ofType: ".sqlite")
        let destinationPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let placeLocation = URL(fileURLWithPath: destinationPath).appendingPathComponent("todo_app.sqlite")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: placeLocation.path) {
            print("Database already exist")
        }else {
            do {
                try fileManager.copyItem(atPath: bandlePath!, toPath: placeLocation.path)
            }catch {}
        }
        
    }
}

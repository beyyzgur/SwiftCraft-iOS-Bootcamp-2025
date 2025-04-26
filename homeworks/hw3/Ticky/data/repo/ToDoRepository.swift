//
//  ToDoRepository.swift
//  Ticky
//
//  Created by beyyzgur on 24.04.2025.
//

import Foundation
import RxSwift
class ToDoRepository {
    var toDosList = BehaviorSubject<[ToDoModel]>(value: [ToDoModel] ())
    var isSearching:Bool = false
    let db:FMDatabase?
    
    init() {
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veritabaniYolu = URL(fileURLWithPath: hedefYol).appendingPathComponent( "todo_app.sqlite")
        db = FMDatabase(path: veritabaniYolu.path)
    }
    
    func save(toDo_title: String){
        db?.open()
        
        do{
            try db!.executeUpdate("INSERT INTO toDos (name, isDone) VALUES (?,?)", values: [toDo_title, 0])
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func update(toDo_id: Int,toDo_title: String){
        db?.open()
        
        do{
            try db!.executeUpdate("UPDATE toDos SET name=? WHERE id=?", values: [toDo_title,toDo_id])
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func search(searchText:String){
        db?.open()
        
        do {
            var liste = [ToDoModel]()
            
            let result = try db!.executeQuery("SELECT * FROM toDos WHERE name LIKE '%\(searchText)%'", values: nil)
            
            while result.next() {
                let toDo_id = Int(result.string(forColumn: "id"))!
                let toDo_title = result.string(forColumn: "name")!
                let toDo_isDone = Int(result.int(forColumn: "isDone"))
                
                let todo = ToDoModel(toDo_id: toDo_id, toDo_title: toDo_title, isDone: toDo_isDone)
                
                liste.append(todo)
            }
            
            toDosList.onNext(liste)//Tetikleme
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func delete(toDo_id:Int){
        db?.open()
        
        do{
            try db!.executeUpdate("DELETE FROM toDos WHERE id=?", values: [toDo_id])
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func isTicked(toDo_id: Int) {
        db?.open()
        
        do {
            try db!.executeUpdate("UPDATE toDos SET isDone = NOT isDone WHERE id = ?", values: [toDo_id])
        } catch {
            print("Tick Update Error \(error.localizedDescription)")
        }
        
        db?.close()
        print("Ticked func çalıştı")
    }
    
    func fetchToDos(){
        db?.open()
        
        do {
            var liste = [ToDoModel]()
            
            let result = try db!.executeQuery("SELECT * FROM toDos", values: nil)
            
            while result.next() {
                let toDo_id = Int(result.string(forColumn: "id"))!
                let toDo_title = result.string(forColumn: "name")!
                let isDone = Int(result.int(forColumn: "isDone"))
                let todo = ToDoModel(toDo_id: toDo_id, toDo_title: toDo_title, isDone: isDone)
                
                liste.append(todo)
            }
            
            toDosList.onNext(liste)//Tetikleme
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
}

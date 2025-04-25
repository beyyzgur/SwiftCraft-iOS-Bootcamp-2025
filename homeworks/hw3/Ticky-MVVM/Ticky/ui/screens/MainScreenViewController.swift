//
//  MainScreenViewController.swift
//  Ticky
//
//  Created by beyyzgur on 19.04.2025.
//
import UIKit

class MainScreenViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var toDosTableView: UITableView!
    //var toDosList = [ToDoModel]()
    var toDosList: [ToDoModel] = []
    var mainScreenViewModel = MainScreenViewModel() 
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad() methodu çalıştı.")
        
        setDelegetesAndDataSources()
        setGestureRecognizer()
        
        _ = mainScreenViewModel.toDosList.subscribe(onNext: { liste in
            self.toDosList = liste
            self.toDosTableView.reloadData()
            
        })
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear fonksiyonu çalıştı")
        mainScreenViewModel.fetchToDos()
        toDosTableView.reloadData()
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let toDo = sender as? ToDoModel {
                let gidilecekViewController = segue.destination as! DetailScreenViewController
                gidilecekViewController.toDo = toDo
            }
        }
        else if segue.identifier == "toSave" {
            if let saveScreenVC = segue.destination as? SaveScreenViewController {
                saveScreenVC.onSave = { [weak self] todoText in
                    let newToDo = ToDoModel(toDo_id: UUID().hashValue, toDo_title: todoText)
                    self?.toDosList.append(newToDo)
                    self?.toDosTableView.reloadData()
                }
            }
            
        }
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toSave", sender: nil)
    }
    
    @objc func didTapTableView() {
        view.endEditing(true)
        print("endddd")
    }
    
    func setDelegetesAndDataSources() {
        toDosTableView.delegate = self
        toDosTableView.dataSource = self
        searchBar.delegate = self
    }
    
    func setGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTableView))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
}

extension MainScreenViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        mainScreenViewModel.search(searchText: searchText)
    }
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDosCell", for: indexPath) as! ToDosCell
        let todo = toDosList[indexPath.row]
        
        cell.labelToDosTitle.text = todo.toDo_title
        cell.isCellTicked(isTicked: todo.isDone)
        cell.onLabelTapped = { [weak self] in
            self?.performSegue(withIdentifier: "toDetail", sender: todo)
        }
        cell.onTickButtonTapped = { [weak self] in
            guard let self = self else {return}
            
            if let indexInMainList = self.toDosList.firstIndex(where: { $0.toDo_id == todo.toDo_id }) {
                self.toDosList[indexInMainList].isDone.toggle()
                self.mainScreenViewModel.isTicked(toDo_id: todo.toDo_id!)
                self.toDosTableView.reloadData()
            }
            //self.toDosList[indexPath.row].isDone.toggle()
            //tableView.reloadRows(at: [indexPath], with: .fade)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = toDosList[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: todo)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in //closure
            
            let todo = self.toDosList[indexPath.row]
            
            let alert = UIAlertController(title: "Delete \(todo.toDo_title ?? "")", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                
                self.mainScreenViewModel.delete(toDo_id: todo.toDo_id!)
            }
            alert.addAction(delete)
            self.present(alert, animated: true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
   }
}

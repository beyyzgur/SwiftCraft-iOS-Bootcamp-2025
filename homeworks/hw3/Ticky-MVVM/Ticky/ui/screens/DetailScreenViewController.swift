//
//  DetailScreenViewController.swift
//  Ticky
//
//  Created by beyyzgur on 19.04.2025.
//
import UIKit

class DetailScreenViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    var detailScreenViewModel = DetailScreenViewModel()
        
    var toDo: ToDoModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tempToDo = toDo {
            titleTextField.text = tempToDo.toDo_title
        }
    }
    
    @IBAction func updateButton(_ sender: Any) {
        if let updatedTitle = titleTextField.text, let tempToDo = toDo {
            detailScreenViewModel.update(toDo_id: tempToDo.toDo_id!, toDo_title: updatedTitle)
        }
        navigationController?.popViewController(animated: true)
    }
}

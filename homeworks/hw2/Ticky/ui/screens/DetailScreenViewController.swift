//
//  DetailScreenViewController.swift
//  Ticky
//
//  Created by beyyzgur on 19.04.2025.
//
import UIKit

class DetailScreenViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
        
    var toDo: ToDoModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tempToDo = toDo {
            titleTextField.text = tempToDo.toDo_title
        }
    }
    
    @IBAction func updateButton(_ sender: Any) {
        if let updatedTitle = titleTextField.text, !updatedTitle.isEmpty {
            toDo?.toDo_title = updatedTitle
            print("geri dönmeye çalışıyorum")
            navigationController?.popViewController(animated: true)
            
        }
    }
}

//
//  SaveScreenViewController.swift
//  Ticky
//
//  Created by beyyzgur on 19.04.2025.
//
import UIKit

class SaveScreenViewController: UIViewController {
    var onSave: ((String) -> Void)?
    
    @IBOutlet weak var titleTextField: UITextField!
    var saveScreenViewModel = SaveScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if let title = titleTextField.text, !title.isEmpty {
            saveScreenViewModel.save(toDo_title: title)
        }
            
        navigationController?.popViewController(animated: true)
   }
}

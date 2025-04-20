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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if let todoText = titleTextField.text, !todoText.isEmpty{
            onSave?(todoText)
            navigationController?.popViewController(animated: true)
        }
    }
}

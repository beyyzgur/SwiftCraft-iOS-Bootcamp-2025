//
//  ViewController.swift
//  DesignStudy
//
//  Created by beyyzgur on 9.04.2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Pizza"
        
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = UIColor(named: "mainColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "textColor1")!,
                                          .font: UIFont(name: "Pacifico-Regular", size: 20)!]
        
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Left - Leading(iOS) - Start (android)
        // Right - Trailing (iOS) - End (android)
        // odevin var - tek sayfa dizayn-app yapmalısın


    }


}


//
//  ViewController.swift
//  BoutiqueDesign
//
//  Created by beyyzgur on 15.04.2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Bouquet Boutique"
        
        let appearance = UINavigationBarAppearance()
    
        appearance.backgroundColor = UIColor(named: "mainColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "textColor1")!,
                                          .font: UIFont(name: "FleurDeLeah-Regular", size: 30)!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }


}


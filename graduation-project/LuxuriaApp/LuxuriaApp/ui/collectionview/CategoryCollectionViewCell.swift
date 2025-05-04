//
//  CategoryCollectionViewCell.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 28.04.2025.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateUI()
    }
    
    func updateUI() {
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.darkPurple.withAlphaComponent(0.5).cgColor
    }

}

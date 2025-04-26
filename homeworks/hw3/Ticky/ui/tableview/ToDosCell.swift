//
//  ToDosCell.swift
//  Ticky
//
//  Created by beyyzgur on 19.04.2025.
//

import UIKit

class ToDosCell: UITableViewCell {
    
    @IBOutlet weak var labelToDosTitle: UILabel!
    @IBOutlet weak var buttonTickButton: UIButton!
    
    var onLabelTapped: (() -> Void)?
    var onTickButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapeGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        labelToDosTitle.isUserInteractionEnabled = true
        labelToDosTitle.addGestureRecognizer(tapeGesture)
    }
    
    @objc func labelTapped() {
        onLabelTapped?() //ViewControllerda tanımlı fonksiyonu çağırıyor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTickClicked(_ sender: UIButton) {
        onTickButtonTapped?()
    }
    
    func isCellTicked(isTicked: Bool) {
        let imageName =   isTicked ? "checkmark.square" : "square"
        buttonTickButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

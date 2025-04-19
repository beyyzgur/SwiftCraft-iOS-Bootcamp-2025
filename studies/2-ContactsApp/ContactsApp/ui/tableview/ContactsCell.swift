//
//  ContactsCell.swift
//  ContactsApp
//
//  Created by beyyzgur on 16.04.2025.
//

import UIKit

class ContactsCell: UITableViewCell {

    @IBOutlet weak var labelContactName: UILabel!
    @IBOutlet weak var labelContactPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

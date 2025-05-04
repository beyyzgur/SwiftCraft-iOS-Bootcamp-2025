//
//  CartTableViewCell.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 3.05.2025.
//

import UIKit
protocol CartTableViewCellDelegate: AnyObject {
    func didClickedTrashButton(cartId: Int)
}

class CartTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    
    var product: CartModel?
    weak var delegate: CartTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func trashButtonClicked(_ sender: UIButton) {
        guard let product = product,
              let cartId = product.cart_id else { return }
        
        delegate?.didClickedTrashButton(cartId: cartId)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with product: CartModel, isFavorite: Bool) {
        self.product = product
        if let productImage = product.image {
            fetchImage(imgName: productImage)
        }
        titleLabel.text = product.name
        if let priceLabel = product.price {
            self.priceLabel.text = "\(String(describing: priceLabel)) ₺"
        }
        
        if let quantity = product.quantity {
            quantityLabel.text = "Quantity: \(quantity)"
        }
    }
    
    func fetchImage(imgName: String) {
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(imgName)") {
            self.imgView.kf.setImage(with: url)
        }
    }
    
}

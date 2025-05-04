//
//  FavoritesTableViewCell.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 3.05.2025.
//

import UIKit

protocol FavoritesTableViewCellDelegate: AnyObject {
    func didTriggeredAddToCartButton(product: ProductModel)
}

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var product: ProductModel?
    weak var delegate: FavoritesTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        guard let product = product else { return }
        delegate?.didTriggeredAddToCartButton(product: product)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with product: ProductModel, isFavorite: Bool) {
        self.product = product
        if let productImage = product.image {
            fetchImage(imgName: productImage)
        }
        titleLabel.text = product.name
        if let priceLabel = product.price {
            self.priceLabel.text = "\(String(describing: priceLabel)) ₺"
        }
    }
    
    func fetchImage(imgName: String) {
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(imgName)") {
            self.imgView.kf.setImage(with: url)
        }
    }
    
}

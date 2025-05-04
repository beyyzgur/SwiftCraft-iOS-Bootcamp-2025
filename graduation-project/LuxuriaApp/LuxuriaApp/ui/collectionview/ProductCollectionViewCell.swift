//
//  ProductCollectionViewCell.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 26.04.2025.
//

import UIKit
import Kingfisher

// protokol yaz. delegate isimli bi temsilci olcak.
// protokol icine func yazacaksin ama protokol icine sadece func'un imzasi yazilir. {} koyulmaz.
// sonra burda olustrdugun protokolun fonksiyonunun nerede kullanmak istiyorsan oraya extension ekle ve bu prokol'u o viewcontroller'a : ile conform et.

protocol ProductCollectionViewCellDelegate: AnyObject {
    func didClickedFavoritesButton(product: ProductModel)
    func didClickedAddToCartButton(product: ProductModel)
}


class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    // protokolun temsilcisini degisken olarak olustur ama "weak var" seklinde olmali.
    weak var delegate: ProductCollectionViewCellDelegate?
    var product: ProductModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateUI()
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        guard let product = product else { return }
        delegate?.didClickedAddToCartButton(product: product)
    }
    
    
    @IBAction func favoritesButtonClicked(_ sender: UIButton) {
        // delegate uzerinden protokolun metodunu cagir
        if let product = product {
            delegate?.didClickedFavoritesButton(product: product)
        }
    }
    
    func configure(with product: ProductModel, isFavorite: Bool) {
        self.product = product
        if let productImage = product.image {
            fetchImage(imgName: productImage)
        }
        titleLabel.text = product.name
        
        categoryLabel.text = product.category
        
        if let priceLabel = product.price {
            self.priceLabel.text = "\(String(describing: priceLabel)) ₺"
        }
        let imageName = FavoritesManager.shared.isFavorite(product) ? "heart.fill" : "heart"
        favoritesButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func fetchImage(imgName: String) {
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(imgName)") {
          self.imageView.kf.setImage(with: url)
        }
    }
    
    func updateUI() {
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.darkPurple.withAlphaComponent(0.5).cgColor
    }
    
}

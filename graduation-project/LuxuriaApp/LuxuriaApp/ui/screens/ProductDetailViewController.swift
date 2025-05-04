//
//  ProductDetailViewController.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 2.05.2025.
//

import UIKit
import Kingfisher

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    
    let productDetailViewModel = ProductDetailViewModel()
    var product: ProductModel?
    var cartList = [CartModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProductDetails()
        
        _ = productDetailViewModel.cartList.subscribe(onNext: { cart in
            self.cartList = cart
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        productDetailViewModel.fetchCart()
    }
    
    @IBAction func favoritesButtonClicked(_ sender: UIButton) {
        guard let product = product else { return }
        
        if FavoritesManager.shared.isFavorite(product) {
            FavoritesManager.shared.removeFavorite(product)
        } else {
            FavoritesManager.shared.addFavorite(product)
        }
        setupProductDetails()
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        guard let product = product else { return }
        
        let (isInCart, quantity, cartId) = checkProductInCart(product: product)
        let viewModelQuantity = productDetailViewModel.quantity
        
        let checkedQuantity = isInCart ? quantity + viewModelQuantity : viewModelQuantity
        
        if isInCart {
            productDetailViewModel.deleteProductFromCart(cartId: cartId)
        }
        
        productDetailViewModel.addProductToCart(product: product, checkedQuantity: checkedQuantity)
    }
    
    @IBAction func quantityMinusButtonClicked(_ sender: UIButton) {
        guard productDetailViewModel.quantity > 1 else { return }
        productDetailViewModel.quantity -= 1
        let quantityString = String(productDetailViewModel.quantity)
        quantityLabel.text = quantityString
    }
    
    @IBAction func quantityPlusButton(_ sender: UIButton) {
        productDetailViewModel.quantity += 1
        let quantityString = String(productDetailViewModel.quantity)
        quantityLabel.text = quantityString
    }
    
    
    func setupProductDetails() {
        if let imageName = product?.image,
           let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(imageName)") {
            imageView.kf.setImage(with: url)
        }
        titleLabel.text = product?.name
        
        if let price = product?.price {
            priceLabel.text = "\(price) ₺"
        }
        
        
        if let product = product {
            let imageName = FavoritesManager.shared.isFavorite(product) ? "heart.fill" : "heart"
            favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    func checkProductInCart(product: ProductModel) -> (isInCart: Bool, quantity: Int, cartId: Int) {
        for item in cartList {
            guard item.name == product.name else { continue }
            guard item.price == product.price else { continue }
            
            if let cartId = item.cart_id {
                let quantity = item.quantity ?? 1
                return (true, quantity, cartId)
            }
        }
        
        return (false, 0, 0)
    }
    
}

//
//  FavoritesViewModel.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 1.05.2025.
//

import Foundation
import RxSwift

class FavoritesViewModel {
    let repo = ProductRepository()
    var cartList = BehaviorSubject<[CartModel]>(value: [CartModel]())
    
    init() {
        cartList = repo.cartList
    }
    
    func fetchCart() {
        repo.fetchProductfromCart()
    }
    
    
    func addProductToCart(product: ProductModel, checkedQuantity: Int) {
        repo.addProductToCart(name: product.name,
                              image: product.image,
                              category: product.category,
                              price: product.price,
                              brand: product.brand,
                              quantity: checkedQuantity)
    }
    
    func deleteProductFromCart(cartId: Int) {
        repo.deleteProductFromCart(cart_id: cartId)
    }
}


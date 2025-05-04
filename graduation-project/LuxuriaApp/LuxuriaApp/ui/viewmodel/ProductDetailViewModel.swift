//
//  ProductDetailViewModel.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 4.05.2025.
//

import Foundation
import RxSwift

class ProductDetailViewModel {
    
    let repo = ProductRepository()
    var cartList = BehaviorSubject<[CartModel]>(value: [CartModel]())
    var quantity: Int = 1
    
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

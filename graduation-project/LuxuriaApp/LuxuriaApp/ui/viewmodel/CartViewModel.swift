//
//  CartViewModel.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 4.05.2025.
//

import Foundation
import RxSwift

class CartViewModel {
    let repo = ProductRepository()
    
    var cartList = BehaviorSubject<[CartModel]>(value: [CartModel]())
    
    init() {
        cartList = repo.cartList
    }
    
    func fetchProductfromCart(userName: String) {
        repo.fetchProductfromCart()
    }
    
    func deleteProductFromCart(productId: Int) {
        repo.deleteProductFromCart(cart_id: productId)
    }
}

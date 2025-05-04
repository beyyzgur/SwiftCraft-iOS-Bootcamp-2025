//
//  HomePageViewModel.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 1.05.2025.
//

import Foundation
import RxSwift

class HomePageViewModel {
    var productRepository = ProductRepository()
    var productList = BehaviorSubject<[ProductModel]>(value: [ProductModel]()) // cekilen tum itemler bunda olcak. vc de bunu kullanarak kac tane hucre gosterilcegini, cellforitem icinde bunun kacinci sirasindaki itemlerin gosterilecegini vs burdan alcam
    var cartList = BehaviorSubject<[CartModel]>(value: [CartModel]())
    
    init() {
        productList = productRepository.productList
        cartList = productRepository.cartList
    }
    
    func fetchProducts() {
        productRepository.fetchAllProduct()
    }
    
    func fetchCart() {
        productRepository.fetchProductfromCart()
    }
    
    func addProductToCart(product: ProductModel, checkedQuantity: Int) {
        productRepository.addProductToCart(name: product.name,
                                           image: product.image,
                                           category: product.category,
                                           price: product.price,
                                           brand: product.brand,
                                           quantity: checkedQuantity)
    }
    
    func deleteProductFromCart(cartId: Int) {
        productRepository.deleteProductFromCart(cart_id: cartId)
    }
}

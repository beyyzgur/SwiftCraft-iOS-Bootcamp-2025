//
//  CardProductModel.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 1.05.2025.
//

import Foundation

class CartProductModel : Codable {
    var urunler_sepeti: [CartModel]?
    var success: Int?
}
class CartModel: Codable {
    var cart_id: Int?
    var name: String?
    var image: String?
    var category: String?
    var price: Int?
    var brand: String?
    var quantity: Int?
    var user_name: String?
    
    enum CodingKeys: String, CodingKey {
        case cart_id = "sepetId"
        case name = "ad"
        case image = "resim"
        case category = "kategori"
        case price = "fiyat"
        case brand = "marka"
        case quantity = "siparisAdeti"
        case user_name = "kullaniciAdi"
    }
    
    convenience init(product: ProductModel, quantity: Int) {
        self.init()
        self.name = product.name
        self.image = product.image
        self.category = product.category
        self.price = product.price
        self.brand = product.brand
        self.quantity = quantity
        self.user_name = "beyyzgur"
    }
}


class VoidResponse: Codable {
    var success: Int?
    var message: String?
}

//
//  ProductModel.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 26.04.2025.
//
import Foundation

class ProductResponseModel: Codable {
    var urunler: [ProductModel]?
    var success: Int?
}

class ProductModel: Codable {
    var id: Int?
    var name: String?
    var image: String?
    var category: String?
    var price: Int?
    var brand: String?
    
    init(id: Int, name: String, image: String, category: String, price: Int, brand: String) {
        self.id = id
        self.name = name
        self.image = image
        self.category = category
        self.price = price
        self.brand = brand
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "ad"
        case image = "resim"
        case category = "kategori"
        case price = "fiyat"
        case brand = "marka"
    }
}



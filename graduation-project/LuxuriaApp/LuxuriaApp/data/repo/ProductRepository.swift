//
//  ProductRepository.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 26.04.2025.
//

import Foundation
import RxSwift

// SORUN 1: request atarken body kisminda json olarak yollamayi kabul etmiyor. o yuzden body kismini url-encode seklinde gondermek gerekiyor istekleri.

// php -> ad=Parf%C3%BCm&resim=parfum.png&kategori=Kozmetik&siparisAdeti=1&marka=Armani&kullaniciAdi=beyyzgur&fiyat=6300

// benim ilk gonderdigim:
//{
//  "resim" : "bilgisayar.png",
//  "kategori" : "Teknoloji",
//  "marka" : "Apple",
//  "ad" : "Bilgisayar",
//  "siparisAdeti" : 1,
//  "fiyat" : 93000,
//  "kullaniciAdi" : "beyyzgur"
//}

class ProductRepository {
    var productList = BehaviorSubject<[ProductModel]>(value: [ProductModel]())
    var cartList = BehaviorSubject<[CartModel]>(value: [CartModel]())
    var userName = "beyyzgur"
    
    func fetchAllProduct() {
        guard let url = URL(string: "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php") else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("API Error : \(error.localizedDescription)")
                return
            }
            guard let data = data else { // data -> Json Datası
                print("Data is nil")
                return
            }
            do{
                let jsonResponse = try JSONDecoder().decode(ProductResponseModel.self, from: data)
                self.productList.onNext(jsonResponse.urunler ?? []) // ürün gelmezse boş array gelsin
                
                print("Data geldi: \(jsonResponse)")
            }catch{
                print("Veri Parse Hatası : \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    func fetchProductfromCart() {
        guard let url = URL(string: "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: String] = [
            "kullaniciAdi": userName
        ]
        
        let postString = parameters.map { "\($0.key)=\($0.value)" }
                                   .joined(separator: "&")
                                   .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        request.httpBody = postString.data(using: .utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("API Error : \(error.localizedDescription)")
                return
            }
            
            guard let data = data,
                  let rawString = String(data: data, encoding: .utf8) else {
                print("Data is nil veya string'e çevrilemedi")
                return
            }

            // SORUN 2: sepetteki urunleri getirirken sepette urun yoksa body de bos string donuyor. bunu decode edemiyoruz. o yuzden bos string kontrolu yaptik.
            if rawString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                // Body tamamen boşsa, sepette ürün yoktur
                self.cartList.onNext([])
                print("Sepet boş. (boş response geldi)")
                return
            }

            // Boş değilse parse etmeyi dene
            do {
                let jsonResponse = try JSONDecoder().decode(CartProductModel.self, from: data)
                self.cartList.onNext(jsonResponse.urunler_sepeti ?? [])
                print("Sepetteki ürünler geldi : \(jsonResponse.urunler_sepeti ?? [])")
            } catch {
                print("JSON Parse Error : \(error.localizedDescription)")
                print("Raw response: \(rawString)")
            }
            
        }.resume()
    }
    
    func addProductToCart(name: String?, image: String?, category: String?, price: Int?, brand: String?, quantity: Int?) {
        guard let name = name,
              let image = image,
              let category = category,
              let price = price,
              let brand = brand,
              let quantity = quantity else {
            print("Urun sepete eklenemedi. Nil deger var.")
            return
        }

        guard let url = URL(string: "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let parameters: [String: String] = [
            "ad": name,
            "resim": image,
            "kategori": category,
            "fiyat": String(price),
            "marka": brand,
            "siparisAdeti": String(quantity),
            "kullaniciAdi": userName
        ]

        let postString = parameters.map { "\($0.key)=\($0.value)" }
                                   .joined(separator: "&")
                                   .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        request.httpBody = postString.data(using: .utf8)

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("API Error : \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Data is nil")
                return
            }

            do {
                let product = try JSONDecoder().decode(VoidResponse.self, from: data)
                self.fetchProductfromCart()
                print("Sepete ürün eklendi : \(product.message) ve success: \(product.success)")
            } catch {
                print("JSON Parse Error : \(error.localizedDescription)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Raw response: \(responseString)")
                }
            }
        }.resume()
    }
    
    func deleteProductFromCart(cart_id: Int) {
        guard let url = URL(string: "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: String] = [
            "sepetId": String(cart_id),
            "kullaniciAdi": userName
        ]
        
        let postString = parameters.map { "\($0.key)=\($0.value)" }
                                   .joined(separator: "&")
                                   .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        request.httpBody = postString.data(using: .utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("API Error : \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Data is nil")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(VoidResponse.self, from: data)
                print("Sepetten ürün silindi : \(response)")
                self.fetchProductfromCart()
            } catch {
                print("JSON parse hatası: \(error.localizedDescription)")
                if let raw = String(data: data, encoding: .utf8) {
                    print("Raw response: \(raw)")
                }
            }
        }.resume()
    }
    
    func isProductInCartObservable(product: ProductModel) -> Observable<(Bool, Int)> {
        return cartList.map { cartItems in
            if let item = cartItems.first(where: { $0.name == product.name && $0.price == product.price }) {
                return (true, item.quantity ?? 1)
            } else {
                return (false, 0)
            }
        }
    }

}

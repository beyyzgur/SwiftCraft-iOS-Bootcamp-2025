//
//  Kisiler.swift
//  ContactsApp
//
//  Created by beyyzgur on 13.04.2025.
//

class Kisiler {
    
    var kisi_id: Int? // soru isaretiyle nill olabileciğini anlar (optional) bu sekilde tanımlamak önemli!!
    var kisi_ad: String?
    var kisi_tel: String?
    
    // Constructor - init func
    // Sınıftan nesne oluşturulduğunda çalışan methodlardır.
    
    init() {}
    
    // dolu constuctor değer girmemizi kolaylastirir
    init(kisi_id: Int, kisi_ad: String, kisi_tel: String) {
           self.kisi_id = kisi_id // Shadowing -> local ve global değişkeni match etme
           self.kisi_ad = kisi_ad
           self.kisi_tel = kisi_tel
       }
    // present modally - sayfa üstüne sayfa açılıyor - parmakla indiriyon sayfayı
    // show - bi sonraki sayfa açılıyo tamamen yeni bi sayfa - bağlıyon bu sayfaya
}

//
//  AnasayfaViewModel.swift
//  ContactsApp
//
//  Created by beyyzgur on 20.04.2025.
//



import Foundation
import RxSwift

class AnasayfaViewModel {
    var kisilerRepository = KisilerRepository()
    var kisilerListesi = BehaviorSubject<[Kisiler]>(value: [Kisiler]())
    
    init() {
        veritabaniKopyala()
        kisilerListesi = kisilerRepository.kisilerListesi // Bağlantı
    }
    
    func ara(aramaKelimesi:String){
        kisilerRepository.ara(aramaKelimesi: aramaKelimesi)
    }
    
    func sil (kisi_id: Int) {
        kisilerRepository.sil(kisi_id: kisi_id)
        KisileriYukle() // sildikten sonra arayüzde kalan verileri yeniden yüklemem lazım ki kalan veriler görünsün sadece
    }
    
    func KisileriYukle() {
        kisilerRepository.KisileriYukle()
    }
    
    func veritabaniKopyala(){
            let bundleYolu = Bundle.main.path(forResource: "rehber", ofType: ".sqlite")
            let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let kopyalanacakYer = URL(fileURLWithPath: hedefYol).appendingPathComponent("rehber.sqlite")
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: kopyalanacakYer.path){
                print("Veritabanı zaten var")
            }else{
                do{
                    try fileManager.copyItem(atPath: bundleYolu!, toPath: kopyalanacakYer.path)
                }catch{}
            }
        }
        
        
}

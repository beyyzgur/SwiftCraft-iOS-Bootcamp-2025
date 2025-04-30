//
//  DetailScreenViewModel.swift
//  ContactsApp
//
//  Created by beyyzgur on 20.04.2025.
//

import Foundation

class KisiDetayViewModel {
    var kisilerRepository = KisilerRepository()
    
    func guncelle(kisi_id:Int,kisi_ad:String,kisi_tel:String){
        kisilerRepository.guncelle(kisi_id: kisi_id, kisi_ad: kisi_ad, kisi_tel: kisi_tel)
    }
}

//
//  SaveScreenViewModel.swift
//  ContactsApp
//
//  Created by beyyzgur on 20.04.2025.
//

import Foundation

class KisiKayitViewModel {
    var kisilerRepository = KisilerRepository()
    
    func kaydet(kisi_ad:String,kisi_tel:String){
        kisilerRepository.kaydet(kisi_ad: kisi_ad, kisi_tel: kisi_tel)
    }
}

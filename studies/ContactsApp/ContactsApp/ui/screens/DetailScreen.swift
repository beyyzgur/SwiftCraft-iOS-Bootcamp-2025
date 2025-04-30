//
//  DetailScreen.swift
//  ContactsApp
//
//  Created by beyyzgur on 13.04.2025.
//

import UIKit

class DetailScreen: UIViewController {
    @IBOutlet weak var tfKisiAd: UITextField!
    @IBOutlet weak var tfKisiTel: UITextField!
    var kisiDetayViewModel = KisiDetayViewModel()
    
    var kisi:Kisiler?
    // hocam sizinkinde emülator calistiramadim ondan kendi projeme gecmistim
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tempKisi = kisi {
            tfKisiAd.text = tempKisi.kisi_ad
            tfKisiTel.text = tempKisi.kisi_tel
        }
        
    }
    
    @IBAction func buttonGuncelle(_ sender: Any) {
        if let ad = tfKisiAd.text,let tel = tfKisiTel.text,let tempKisi = kisi {
        kisiDetayViewModel.guncelle(kisi_id: tempKisi.kisi_id!, kisi_ad: ad, kisi_tel: tel)

        }
        // Bir önceki sayfaya geri döner
        //navigationController?.popViewController(animated: true)
        // pop behavior - pop davranısı - pop key'i sayfayı geriye döndüren func
        
        // en baştaki sayfaya döner
        //navigationController?.popToRootViewController(animated: true)
        
    }
    
}

// modul sayfa gecisi icin self.dismiss, animation'dan sonraki kod parmakla indirdikten sonra napiyim diye sorar nill bırakabilirsin.

// Tabbar için controlle sürükledikten sonra relationship segue - view controller

//Table view (listeleme sıralama gibi kisiler uygulamasındaki gibi - scroll edebiliyorsun) - Collection view (kutulama)

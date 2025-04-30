//
//  SaveScreen.swift
//  ContactsApp
//
//  Created by beyyzgur on 13.04.2025.
//

import UIKit

class SaveScreen: UIViewController {
    @IBOutlet weak var tfKisiAd: UITextField!
    @IBOutlet weak var tfKisiTel: UITextField!
    var kisiKayitViewModel = KisiKayitViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonKaydet(_ sender: Any) {
        // let sabit, android (val), final, const
        // kullanıcı ne girdiyse onu verir
        if let ad = tfKisiAd.text,
           let tel = tfKisiTel.text { // if let optional binding
        kisiKayitViewModel.kaydet(kisi_ad: ad, kisi_tel: tel)
        }
        
    }
}

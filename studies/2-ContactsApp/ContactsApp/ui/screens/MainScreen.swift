//
//  ViewController.swift
//  ContactsApp
//
//  Created by beyyzgur on 13.04.2025.
//

import UIKit

// struct yapısında kalıtım özelliği yok

// Protocol = Interface
// Protocoller sınıflara özellik katar.
// Bir sınıfa birden fazla protocol eklenebilir.
// Önemli : Kalıtımda bir sınıfa sadece 1 adet sınıf eklenebilir.
//Mesela burada UIViewController bir protocol

class MainScreen: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contactsTableView: UITableView!
    var contactsList = [Kisiler]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Yaşam döngüsü methodu
        // Sayfa açıldığında 1 kere çalışır.
        print("viewDidLoad() methodu çalıştı.")
        searchBar.delegate = self
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        let k1 = Kisiler(kisi_id: 1, kisi_ad: "Ayaz", kisi_tel: "1111")
        let k2 = Kisiler(kisi_id: 2, kisi_ad: "Beyzoş", kisi_tel: "2222")
        let k3 = Kisiler(kisi_id: 3, kisi_ad: "Maya", kisi_tel: "3333")
        let k4 = Kisiler(kisi_id: 4, kisi_ad: "Reyyoş", kisi_tel: "4444")
        let k5 = Kisiler(kisi_id: 5, kisi_ad: "Gümüş", kisi_tel: "5555")
        let k6 = Kisiler(kisi_id: 6, kisi_ad: "Teyzoş", kisi_tel: "6666")
        let k7 = Kisiler(kisi_id: 7, kisi_ad: "Anniş", kisi_tel: "7777")
        let k8 = Kisiler(kisi_id: 8, kisi_ad: "Aşkım", kisi_tel: "8888")
        let k9 = Kisiler(kisi_id: 9, kisi_ad: "Babiş", kisi_tel: "9999")
        contactsList.append(k1)
        contactsList.append(k2)
        contactsList.append(k3)
        contactsList.append(k4)
        contactsList.append(k5)
        contactsList.append(k6)
        contactsList.append(k7)
        contactsList.append(k8)
        contactsList.append(k9)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Sayfa her göründüğünde çalışır.
        // Sayfaya geri dönüldüğünü anlayabiliriz.
        print("viewWillAppear() çalıştı.") // genelde will kullanilir, did genellikle kullanılmaz dedi.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Sayfa her görünmez olduğunda çalışır.
        print("viewDidDisappear() çalıştı.")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("geçiş yapıldı")
        if segue.identifier == "toDetay" {
            print("toDetay çalıştı")
            // Any: bu tür bütün sınıfların üstündedir
            if let kisi = sender as? Kisiler { // as? demek downcasting: superclassı subclass'a dönüştürmektir.
                print("Veri: \(kisi.kisi_ad!)")
                let gidilecekVC = segue.destination as! DetailScreen
                // as?: downcasting, hata olma ihtimali yüksekte bunu kullanıyoruz.
                // as!: downcasting, hata olma ihtimali düşükse bunu kullanıyoruz.
                gidilecekVC.kisi = kisi
            }
        }
    }
}

extension MainScreen : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Kişi Ara : \(searchText)")
    }
}

extension MainScreen : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsList.count
       }// kaç tane satır olusturacak
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Satır sayısına göre tekrarlı çalışacak.
        let hucre = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath) as! ContactsCell
        //0,1,2
        let kisi = contactsList[indexPath.row]
        
        hucre.labelContactName.text = kisi.kisi_ad
        hucre.labelContactPhone.text = kisi.kisi_tel
        
        return hucre
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let kisi = contactsList[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: kisi)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .destructive, title: "Sil") { (contextualAction, view, bool) in // closure
            
            let kisi = self.contactsList[indexPath.row]
            
            let alert = UIAlertController(title: "Silme İşlemi", message: "\(kisi.kisi_ad!) silinsin mi?", preferredStyle: .alert) // kisi_ad'ından sonra ünlem koymayı unutma yoksa optional yazar.
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(iptalAction)
            
            let silAction = UIAlertAction(title: "Sil", style: .destructive) { (action) in
                print("Kişi Sil : \(kisi.kisi_id!)")
            
            }
            alert.addAction(silAction)
            self.present(alert, animated: true)
        }
        return UISwipeActionsConfiguration(actions: [silAction])
    }
    
}


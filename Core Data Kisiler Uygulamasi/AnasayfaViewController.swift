//
//  ViewController.swift
//  Core Data Kisiler Uygulamasi
//
//  Created by Seyfullah Daldal on 20.09.2022.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class AnasayfaViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext //veri kayıt işlemleri yapılacak

   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var listeAd = [Kisiler]()
    
    var aramaYapiliyorMu = false
    var aramaKelimesi : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.hidesBackButton = true
               
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        kisileriAl()
        tableView.reloadData()
         
        
    }
    
    @IBAction func ekleButton(_ sender: Any) {
        
        performSegue(withIdentifier: "toEkle", sender: nil)
       
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indeks = sender as? Int
        
        
        if segue.identifier == "toEkle" {
            
            let destinationVC = segue.destination as! EkleGuncelleViewController
            destinationVC.isEnableGuncelle = false
            destinationVC.title = "Kisi Ekle"
            
        }
        
        if segue.identifier == "toDetay" {
            
           
            let destinationVC = segue.destination as! EkleGuncelleViewController
            destinationVC.isEkleHidden = true
            destinationVC.isGuncelleHidden = true
            destinationVC.kisi = listeAd[indeks!]
            destinationVC.title = "Kişi Ayrıntı"
            
        }
        
        if segue.identifier == "toGuncelle" {
            
                        
            let destinationVc = segue.destination as! EkleGuncelleViewController
            destinationVc.isEnableEkle = false
            destinationVc.kisi = listeAd[indeks!]
            destinationVc.title = "Kişi Güncelle"
            
            //burada kaldık dersi dinle 
           
        }
    }
    
    func kisileriAl() {
        
        do {
            listeAd = try context.fetch(Kisiler.fetchRequest())
        } catch {
            print("Hata")
        }
        
        
    }
    
    func aramaYap(kisi_ad:String){
        
        let fetchRequest : NSFetchRequest <Kisiler> = Kisiler.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "kisi_ad CONTAINS %@", kisi_ad)
        
        do {
            listeAd = try context.fetch(fetchRequest)
        } catch {
            print("Arama Hatalı")
        }
        
    }
    
}

extension AnasayfaViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listeAd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "kisiHucre", for: indexPath) as! KisilerTableViewCell
        cell.kisiAdLabel.text = listeAd[indexPath.row].kisi_ad
        cell.kisiNumaraLabel.text = listeAd[indexPath.row].kisi_numara
        cell.kisiMailLabel.text = listeAd[indexPath.row].kisi_mail
               
        
        if let imageData = listeAd[indexPath.row].kisi_resim as Data? {
            cell.kisiImageView.image = UIImage(data: imageData)
        }
         
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .normal, title: "Sil") { (contextualAction, view, boolValue) in
            
            let kisi = self.listeAd[indexPath.row]
            
            self.context.delete(kisi)
            
            appDelegate.saveContext()
            self.kisileriAl()
            self.tableView.reloadData()
            
        }
        
        let duzenleAction = UIContextualAction(style: .destructive, title: "Güncelle") { (contextualaction, view, boolvalue) in
                       
            
            self.performSegue(withIdentifier: "toGuncelle", sender: indexPath.row)
        }
        
        let ayrintiAction = UIContextualAction(style: .normal, title: "Ayrıntı") { (contextualaction, view, boolvalue) in
            
            self.performSegue(withIdentifier: "toDetay", sender: indexPath.row)
            
        }
        
        return UISwipeActionsConfiguration(actions: [silAction, duzenleAction, ayrintiAction])
    }
    
    
}

extension AnasayfaViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("\(searchText.lowercased())")
        
        aramaKelimesi = searchText
        
        if searchText == "" {
            
            aramaYapiliyorMu = false
            kisileriAl()
            
        } else {
            aramaYapiliyorMu = true
            self.aramaYap(kisi_ad: aramaKelimesi!)
        }
                     
        tableView.reloadData()
        
        
    }
    
    
}

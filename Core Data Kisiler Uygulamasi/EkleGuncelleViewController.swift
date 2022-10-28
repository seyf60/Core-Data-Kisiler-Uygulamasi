//
//  EkleGuncelleViewController.swift
//  Core Data Kisiler Uygulamasi
//
//  Created by Seyfullah Daldal on 20.09.2022.
//

import UIKit
import CoreData
import PhotosUI

class EkleGuncelleViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var kisiResim: UIImageView!
    @IBOutlet weak var kisininMail: UITextField!
    @IBOutlet weak var kisininNumarasi: UITextField!
    @IBOutlet weak var kisininAdi: UITextField!
    @IBOutlet weak var ekleButtonOutlet: UIButton!
    @IBOutlet weak var guncelleButtonOutlet: UIButton!
    
    var isEnableGuncelle = true
    var isEnableEkle = true
    
    var isGuncelleHidden = false
    var isEkleHidden = false
        
    var kisi : Kisiler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.guncelleButtonOutlet.isEnabled = isEnableGuncelle
        self.ekleButtonOutlet.isEnabled = isEnableEkle
       
        self.guncelleButtonOutlet.isHidden = isGuncelleHidden
        self.ekleButtonOutlet.isHidden = isEkleHidden
                
        kisiResim.isUserInteractionEnabled = true
        
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        kisiResim.addGestureRecognizer(imageTapRecognizer)
      
        if let k = kisi {
            
            kisininAdi.text = k.kisi_ad
            kisininNumarasi.text = k.kisi_numara
            kisininMail.text = k.kisi_mail            
            kisiResim.image = UIImage(data: k.kisi_resim!)
        }
    }

    @IBAction func ekleButton(_ sender: Any) {
        
        let kisi = Kisiler(context: context)
        
        if let ad = kisininAdi.text, let numara = kisininNumarasi.text, let mail = kisininMail.text {
            
            let imageDate = kisiResim.image!.jpegData(compressionQuality: 0.5)
            
            kisi.kisi_resim = imageDate
            kisi.kisi_ad = ad
            kisi.kisi_numara = numara
            kisi.kisi_mail = mail
                        
            appDelegate.saveContext()
            
        }
        
        alertMessage(titleInput: "Uyarı", messageInput: "Kişi Başarıyla Kayıt Edildi")
        
    }
    
    
    @IBAction func guncelleButton(_ sender: Any) {
        
        if let k = kisi, let ad = kisininAdi.text, let numara = kisininNumarasi.text, let mail = kisininMail.text {
            
            let imageData = kisiResim.image!.jpegData(compressionQuality: 0.5)
            
            k.kisi_ad = ad
            k.kisi_numara = numara
            k.kisi_mail = mail
            k.kisi_resim = imageData
            
            appDelegate.saveContext()
            
        }
        
        alertMessage(titleInput: "Uyarı", messageInput: "Kayıt Başarıyla Güncellendi")
        
    }
    
    @objc func tapImage() {
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images
        
        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true)
    }
    
    func alertMessage(titleInput: String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let tamamAction = UIAlertAction(title: "Tamam", style: .default) { uialertAction in
                      
            self.performSegue(withIdentifier: "toKisiler", sender: nil)
                        
        }
        
        alert.addAction(tamamAction)
        self.present(alert, animated: true)
        
    }
    
    
}

extension EkleGuncelleViewController : PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
     
        guard let result = results.first else { return }
        let prov = result.itemProvider
        prov.loadObject(ofClass: UIImage.self) { imageMaybe, errorMaybe in
            
            if let image = imageMaybe as? UIImage {
                DispatchQueue.main.async {
                    self.kisiResim.image = image
                    self.dismiss(animated: true)
                }
            }
            
        }
}
}


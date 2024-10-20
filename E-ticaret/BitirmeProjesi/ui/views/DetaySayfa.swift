//
//  DetaySayfa.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 8.10.2024.
//


import UIKit

class DetaySayfa: UIViewController {

    @IBOutlet weak var labelAdet: UILabel!
    @IBOutlet weak var imageViewUrun: UIImageView!
    @IBOutlet weak var labelUrunFiyat: UILabel!
    @IBOutlet weak var labelUrunAd: UILabel!
    @IBOutlet weak var buttonSepeteEkle: UIButton!
    
    var viewModel = DetaySayfaViewModel()
    var urun: Urunler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "\(urun!.ad!)"
        if let urun = urun {
            viewModel.urun = urun
            viewModel.siparisAdeti = 1 // Başlangıçta sipariş adeti 1 olarak ayarlıyoruz
            viewModel.urunFiyati = urun.fiyat!
            
            labelUrunAd.text = urun.ad
            labelUrunFiyat.text = viewModel.urunFiyatGuncelle()
            labelAdet.text = "\(viewModel.siparisAdeti)"
            
            if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(urun.resim!)") {
                DispatchQueue.main.async {
                    self.imageViewUrun.kf.setImage(with: url)
                }
            }
        }
    }
    
    @IBAction func buttonSepeteEkle(_ sender: Any) {
        viewModel.sepeteEkle()
        sepeteEkleButonAnimasyonu()
    }
    
    @IBAction func buttonAdetAzalt(_ sender: Any) {
        viewModel.adetAzalt()
        guncelleGorunum()
    }
    
    @IBAction func buttonAdetArttır(_ sender: Any) {
        viewModel.adetArttir()
        guncelleGorunum()
    }
    
    private func guncelleGorunum() {
        labelAdet.text = "\(viewModel.siparisAdeti)"
        labelUrunFiyat.text = viewModel.urunFiyatGuncelle()
    }
    
    private func sepeteEkleButonAnimasyonu() {
        UIView.transition(with: buttonSepeteEkle, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.buttonSepeteEkle.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.transition(with: self.buttonSepeteEkle, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.buttonSepeteEkle.setImage(UIImage(systemName: "plus"), for: .normal)
            }, completion: nil)
        }
    }
}

//
//  FavorilerHucre.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 15.10.2024.
//


import UIKit

protocol FavorilerHucreDelegate: AnyObject {
    func favoriUrunSilindi(_ hucre: FavorilerHucre)
    func sepeteEkle(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String)
}

class FavorilerHucre: UICollectionViewCell {
    
    @IBOutlet weak var labelAd: UILabel!
    @IBOutlet weak var labelFiyat: UILabel!
    @IBOutlet weak var imageViewUrun: UIImageView!
    @IBOutlet weak var buttonHeart: UIButton!
    @IBOutlet weak var buttonSepeteEkle: UIButton!
    var favorilerProtocol:FavorilerHucreDelegate?
    
    var urun: Urunler?
    var viewModel: FavorilerViewModel?  // ViewModel üzerinden favori işlemleri
    weak var delegate: FavorilerHucreDelegate?  // Delegate tanımlıyoruz
    var kullaniciAdi = "buraksatir"
    
    @IBAction func buttonHeartTapped(_ sender: UIButton) {
        // Ürünü favorilerden sil
        if let urun = urun {
            viewModel?.favoriCikar(urun: urun)
        }
        
        // Kalp simgesini boş yapıyoruz
        buttonHeart.setImage(UIImage(systemName: "heart"), for: .normal)
        
        // Delegate ile favori ürünün silindiğini bildiriyoruz
        delegate?.favoriUrunSilindi(self)
    }
    
    @IBAction func buttonSepeteEkle(_ sender: UIButton) {
        favorilerProtocol?.sepeteEkle(ad: (urun?.ad!)!, resim: (urun?.resim!)!, kategori: (urun?.kategori!)!, fiyat: (urun?.fiyat)!, marka: (urun?.marka)!, siparisAdeti: 1, kullaniciAdi: kullaniciAdi)
        
        UIView.transition(with: buttonSepeteEkle, duration: 0.3, options: .transitionFlipFromTop, animations: {
            self.buttonSepeteEkle.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }, completion: nil)
        
        // 3 saniye sonra butonu eski haline döndür
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.transition(with: self.buttonSepeteEkle, duration: 0.3, options: .transitionFlipFromTop, animations: {
                self.buttonSepeteEkle.setImage(UIImage(systemName: "plus"), for: .normal)
            }, completion: nil)
        }
    }
}

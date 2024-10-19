//
//  UrunlerHucre.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 8.10.2024.
//

import UIKit
import Lottie

protocol UrunlerProtocol {
    func sepeteEkle(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String)
}

class UrunlerHucre: UICollectionViewCell {
    var kullaniciAdi = "buraksatir"
    var favorilerRepository = FavorilerRepository.shared // Favoriler repository'yi tanımlıyoruz
    
    @IBOutlet weak var labelAd: UILabel!
    @IBOutlet weak var imageViewUrun: UIImageView!
    @IBOutlet weak var labelFiyat: UILabel!
    @IBOutlet weak var buttonSepetEkle: UIButton!
    @IBOutlet weak var buttonHeart: UIButton!  // Heart button'a outlet ekledik
    
    var urunlerProtocol: UrunlerProtocol?
    var urun: Urunler?
    var heartAnimationView: LottieAnimationView? // Lottie animasyonu için
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Lottie animasyonunu URL
        if let url = URL(string: "https://lottie.host/ca7f6288-8e71-47f0-86cd-487636dd9a57/Q4EuuC69MI.json") {
            heartAnimationView = LottieAnimationView(url: url, closure: { (error) in
                if let error = error {
                    print("Lottie animasyon yüklenirken hata oluştu: \(error.localizedDescription)")
                }
            })
            heartAnimationView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)  // Animasyon boyutlarını ayarla
            heartAnimationView?.center = contentView.center  // Animasyonu hücre ortasına konumlandır
            heartAnimationView?.contentMode = .scaleAspectFit
            heartAnimationView?.loopMode = .playOnce  // Animasyon bir kez oynasın
            heartAnimationView?.isHidden = true  // Başlangıçta gizli olsun
            contentView.addSubview(heartAnimationView!)  // Animasyonu hücreye ekle
        }
    }
    
    @IBAction func buttonSepeteEkle(_ sender: Any) {
        urunlerProtocol?.sepeteEkle(ad: (urun?.ad!)!, resim: (urun?.resim!)!, kategori: (urun?.kategori!)!, fiyat: (urun?.fiyat)!, marka: (urun?.marka)!, siparisAdeti: 1, kullaniciAdi: kullaniciAdi)
        
        UIView.transition(with: buttonSepetEkle, duration: 0.3, options: .transitionFlipFromTop, animations: {
            self.buttonSepetEkle.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.transition(with: self.buttonSepetEkle, duration: 0.3, options: .transitionFlipFromTop, animations: {
                self.buttonSepetEkle.setImage(UIImage(systemName: "plus"), for: .normal)
            }, completion: nil)
        }
    }
    
    @IBAction func buttonHeartTapped(_ sender: UIButton) {
        guard let urun = urun else { return }
            // Ürünü favorilere ekle
            favorilerRepository.favoriEkle(urun: urun)
        
        // Animasyonu göster ve oynat
        heartAnimationView?.isHidden = false
        heartAnimationView?.play { [weak self] (finished) in
            // Animasyon bitince tekrar gizle
            self?.heartAnimationView?.isHidden = true
        }
    }
}

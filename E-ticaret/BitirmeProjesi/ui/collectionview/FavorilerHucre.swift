//
//  FavorilerHucre.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 15.10.2024.
//


import UIKit

protocol FavorilerHucreDelegate: AnyObject {
    func favoriUrunSilindi(_ hucre: FavorilerHucre)
}

class FavorilerHucre: UICollectionViewCell {

    @IBOutlet weak var labelAd: UILabel!
    @IBOutlet weak var labelFiyat: UILabel!
    @IBOutlet weak var imageViewUrun: UIImageView!
    @IBOutlet weak var buttonHeart: UIButton!
    
    var urun: Urunler?
    var viewModel: FavorilerViewModel?  // ViewModel üzerinden favori işlemleri
    weak var delegate: FavorilerHucreDelegate?  // Delegate tanımlıyoruz

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
}

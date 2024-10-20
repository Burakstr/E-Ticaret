//
//  FavorilerSayfa.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 17.10.2024.
//

import UIKit
import RxSwift

class FavorilerSayfa: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FavorilerHucreDelegate {
        

    @IBOutlet weak var favorilerCollectionView: UICollectionView!
    
    var favorilerListesi: [Urunler] = []
    var viewModel = FavorilerViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favorilerCollectionView.delegate = self
        favorilerCollectionView.dataSource = self

        // Favoriler repository'den favori listesini dinle
        FavorilerRepository.shared.favorilerListesi
            .subscribe(onNext: { [weak self] favoriler in
                self?.favorilerListesi = favoriler
                self?.favorilerCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "Color1") // Mor renk
        
        // Navigation bar'daki başlık ve buton yazı renklerini beyaz yap
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // ScrollEdgeAppearance, CompactAppearance ve StandardAppearance ayarları
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        self.navigationItem.title = "Favorilerim"
        
        let tasarim = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
        tasarim.minimumInteritemSpacing = 10
        tasarim.minimumLineSpacing = 10
        
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 30) / 2
        tasarim.itemSize = CGSize(width: itemGenislik, height: itemGenislik * 1.7)
        favorilerCollectionView.collectionViewLayout = tasarim
    }
    
    // Favorilerdeki hücre sayısı
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorilerListesi.count
    }
    
    // Hücre oluşturma
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: "favorilerHucre", for: indexPath) as! FavorilerHucre
        let urun = favorilerListesi[indexPath.row]
        
        hucre.labelAd.text = urun.ad
        hucre.labelFiyat.text = "\(urun.fiyat!) ₺"
        
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(urun.resim!)") {
            DispatchQueue.main.async {
                hucre.imageViewUrun.kf.setImage(with: url)
            }
        }
        
        hucre.buttonHeart.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        hucre.favorilerProtocol = self
        hucre.urun = urun
        hucre.viewModel = FavorilerViewModel()  // ViewModel ataması
        hucre.delegate = self  // Delegate ataması
        
        return hucre
    }

    // FavorilerHucreDelegate fonksiyonu
    func favoriUrunSilindi(_ hucre: FavorilerHucre) {
        // Hücrenin indexPath'ini alıyoruz
        if let indexPath = favorilerCollectionView.indexPath(for: hucre) {
            // Ürünü favoriler listesinden çıkarıyoruz
            favorilerListesi.remove(at: indexPath.row)
            
            // CollectionView'den animasyonlu olarak hücreyi kaldırıyoruz
            favorilerCollectionView.performBatchUpdates({
                favorilerCollectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        }
    }
    
    func sepeteEkle(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String) {
        viewModel.sepeteEkle(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi)
    }

}

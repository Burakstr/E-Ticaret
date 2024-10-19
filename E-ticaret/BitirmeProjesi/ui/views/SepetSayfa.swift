//
//  SepetSayfa.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 9.10.2024.
//

import UIKit
import Lottie

class SepetSayfa: UIViewController {

    @IBOutlet weak var labelToplamFiyat: UILabel!
    @IBOutlet weak var labelToplam: UILabel!
    @IBOutlet weak var sepetTableView: UITableView!
    
    var sepetListesi = [UrunlerSepeti]()
    var viewModel = SepetSayfaViewModel()
    var kullaniciAdi = "buraksatir"
    let titleLabel = UILabel()
    var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView = LottieAnimationView(name: "cartAnimation")  // Animasyon dosyanızın ismi
                animationView?.frame = CGRect(x: 0, y: 0, width: 200, height: 200)  // Animasyon boyutlarını ayarla
                animationView?.center = view.center  // Ekran ortasında konumlandır
                animationView?.contentMode = .scaleAspectFit
                animationView?.loopMode = .playOnce  // Sadece bir kez oynat
                animationView?.isHidden = true  // Başlangıçta gizli olsun
                
                view.addSubview(animationView!)  // Animasyonu görünümde ekle
        
        
        
        // Navigation Bar Renk Ayarı
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "Color1") // Mor renk
        
        // Navigation bar'daki başlık ve buton yazı renklerini beyaz yap
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // ScrollEdgeAppearance, CompactAppearance ve StandardAppearance ayarları
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        self.navigationItem.title = "Sepetim"
        


        sepetTableView.delegate = self
        sepetTableView.dataSource = self
        
        _ = viewModel.sepetListesi.subscribe(onNext: { liste in
            self.sepetListesi = liste
            DispatchQueue.main.async{
                self.sepetTableView.reloadData()
                self.toplamFiyatHesapla()  // Toplam fiyatı hesapla ve label'a yaz
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.sepetiYukle(kullaniciAdi: kullaniciAdi)
        DispatchQueue.main.async{
            self.sepetTableView.reloadData()
            self.toplamFiyatHesapla()  // Toplam fiyatı hesapla ve label'a yaz
        }
    }
    
    @IBAction func buttonSiparisTamamla(_ sender: Any) {
        // Lottie animasyonunu göster ve oynat
        animationView?.isHidden = false
        animationView?.play { (finished) in
            // Animasyon bitince gizle
            self.animationView?.isHidden = true
        }
    }
    
    func toplamFiyatHesapla() {
        var toplamFiyat: Double = 0.0
        
        for urun in sepetListesi {
            if let fiyat = urun.fiyat, let adet = urun.siparisAdeti {
                toplamFiyat += Double(fiyat * Int(adet))
            }
        }
        
        // Toplam fiyatı label'a yazdır
        labelToplamFiyat.text = "\(toplamFiyat) ₺"
    }
}

extension SepetSayfa: UITableViewDelegate, UITableViewDataSource,HucreProtocol {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepetListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let urun = sepetListesi[indexPath.row]
        
        let hucre = tableView.dequeueReusableCell(withIdentifier: "sepetHucre") as! SepetHucre
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(urun.resim!)"){
            DispatchQueue.main.async{
                hucre.imageViewSepet.kf.setImage(with: url)
            }
        }
       
        hucre.labelSepetAd.text = urun.ad
        hucre.labelSepetFiyat.text = "\(urun.fiyat! * urun.siparisAdeti!) ₺"
        hucre.labelSepetAdet.text = "\(urun.siparisAdeti!) "
        hucre.hucreProtocol = self
        hucre.indexPath = indexPath
        hucre.siparisAdeti = urun.siparisAdeti

        
        // Silme butonuna basıldığında çalışacak closure'u bağla
        hucre.silAction = { [weak self] in
            guard let self = self else { return }
            
            let alert = UIAlertController(title: "Silme İşlemi", message: "\(urun.ad!) silinsin mi?", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(iptalAction)
            
            let evetAction = UIAlertAction(title: "Evet", style: .destructive) { action in
                // İlk olarak modeli güncelle
                self.viewModel.sil(sepetId: urun.sepetId!, kullaniciAdi: urun.kullaniciAdi!)
                
                // Veri kaynağından öğeyi kaldır
                self.sepetListesi.remove(at: indexPath.row)
                
                // TableView'dan animasyonla satırı sil
                self.sepetTableView.beginUpdates()
                self.sepetTableView.deleteRows(at: [indexPath], with: .fade)  // Animasyonlu silme işlemi
                self.sepetTableView.endUpdates()

                // Toplam fiyatı güncelle
                self.toplamFiyatHesapla()

                // Modelde ve kullanıcı arayüzünde eş zamanlı güncelleme sağla
                DispatchQueue.main.async {
                    self.sepetTableView.reloadData()
                }
            }
            alert.addAction(evetAction)
            
            self.present(alert, animated: true)
        }

        
        return hucre
    }
    func sepetiArtırTıklandı(indexPath: IndexPath, siparisAdeti: Int) {
        let urun = sepetListesi[indexPath.row]
        urun.siparisAdeti! += 1
        sepetListesi[indexPath.row] = urun
        toplamFiyatHesapla()  // Toplam fiyatı güncelle
        sepetTableView.reloadRows(at: [indexPath], with: .automatic)
        viewModel.sepeteEkle(ad: urun.ad!, resim: urun.resim!, kategori: urun.kategori!, fiyat: urun.fiyat!, marka: urun.marka!, siparisAdeti: 1, kullaniciAdi: kullaniciAdi)
    }

    func sepetiAzaltTıklandı(indexPath: IndexPath, siparisAdeti: Int) {
        let urun = sepetListesi[indexPath.row]
        if urun.siparisAdeti! > 1 {
            urun.siparisAdeti! -= 1
            sepetListesi[indexPath.row] = urun
            toplamFiyatHesapla()  // Toplam fiyatı güncelle
            sepetTableView.reloadRows(at: [indexPath], with: .automatic)
            viewModel.sil(sepetId: urun.sepetId!, kullaniciAdi: kullaniciAdi)
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

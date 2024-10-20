//
//  UrunlerRepository.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 8.10.2024.
//

import Foundation
import RxSwift
import Alamofire

class UrunlerRepository {
    var urunlerListesi = BehaviorSubject<[Urunler]>(value: [Urunler]())
    var sepetListesi = BehaviorSubject<[UrunlerSepeti]>(value: [UrunlerSepeti]())
    var kullaniciAdi = "buraksatir"
    
    func sil(sepetId: Int, kullaniciAdi: String) {
        let params: Parameters = ["sepetId": sepetId, "kullaniciAdi": kullaniciAdi]
        AF.request("http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    if cevap.success == 1 {
                        print("Silindi: \(cevap.message!)")
                    } else {
                        print("Silme başarısız: \(cevap.message!)")
                    }
                } catch {
                    print("Hata: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func sepetiYukle(kullaniciAdi: String) {
        let params: Parameters = ["kullaniciAdi": kullaniciAdi]
        AF.request("http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(UrunlerSepetiCevap.self, from: data)
                    if let liste = cevap.urunler_sepeti {
                        // Aynı ada sahip ürünleri gruplayarak adetlerini topla
                        let gruplanmisSepet = Dictionary(grouping: liste, by: { $0.ad }).map { (key, value) -> UrunlerSepeti in
                            let toplamAdet = value.reduce(0) { $0 + ($1.siparisAdeti ?? 0) }
                            let urun = value.first!
                            urun.siparisAdeti = toplamAdet
                            return urun
                        }
                        
                        // Ürünleri ada göre alfabetik olarak sırala
                        let siralanmisSepet = gruplanmisSepet.sorted { $0.ad!.lowercased() < $1.ad!.lowercased() }
                        
                        // Sepet listesini güncelle
                        self.sepetListesi.onNext(siralanmisSepet)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func urunleriYukle() {
        AF.request("http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php", method: .get).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(UrunlerCevap.self, from: data)
                    if let liste = cevap.urunler {
                        self.urunlerListesi.onNext(liste)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func sepeteEkle(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String) {
        let params: Parameters = ["ad": ad, "resim": resim, "kategori": kategori, "fiyat": fiyat, "marka": marka, "siparisAdeti": siparisAdeti, "kullaniciAdi": kullaniciAdi]
        
        AF.request("http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("\(cevap.success!)")
                    print("\(cevap.message!)")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

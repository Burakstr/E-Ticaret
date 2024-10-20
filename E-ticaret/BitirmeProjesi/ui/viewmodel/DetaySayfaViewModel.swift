//
//  DetaySayfaViewModel.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 8.10.2024.
//


import Foundation

class DetaySayfaViewModel {
    var urepo = UrunlerRepository()
    var urun: Urunler?
    var kullaniciAdi = "buraksatir"
    var siparisAdeti = 1
    var urunFiyati: Int = 0
    
    func sepeteEkle() {
        if let urun = urun {
            urepo.sepeteEkle(ad: urun.ad!, resim: urun.resim!, kategori: urun.kategori!, fiyat: urunFiyati, marka: urun.marka!, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi)
        }
    }
    
    func adetAzalt() {
        if siparisAdeti > 1 {
            siparisAdeti -= 1
        }
    }
    
    func adetArttir() {
        siparisAdeti += 1
    }
    
    func urunFiyatGuncelle() -> String {
        return "\(urunFiyati * siparisAdeti) ₺"
    }
}

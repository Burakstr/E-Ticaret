//
//  SepetSayfaViewModel.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 9.10.2024.
//


import Foundation
import RxSwift

class SepetSayfaViewModel {
    var urepo = UrunlerRepository()
    var sepetListesi = BehaviorSubject<[UrunlerSepeti]>(value: [UrunlerSepeti]())
    var kullaniciAdi = "buraksatir"
    
    
    init(){
        sepetListesi = urepo.sepetListesi
        sepetiYukle(kullaniciAdi: kullaniciAdi)
    }
    func sepetiYukle(kullaniciAdi:String){
        urepo.sepetiYukle(kullaniciAdi:kullaniciAdi)
    }
    func sil(sepetId:Int,kullaniciAdi:String){
        urepo.sil(sepetId: sepetId, kullaniciAdi: kullaniciAdi)
        sepetiYukle(kullaniciAdi: kullaniciAdi)
    }
    func sepeteEkle(ad:String,resim:String,kategori:String,fiyat:Int,marka:String,siparisAdeti:Int,kullaniciAdi:String){
        urepo.sepeteEkle(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi)
    }
    
}

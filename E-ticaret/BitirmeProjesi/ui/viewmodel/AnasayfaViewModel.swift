//
//  AnasayfaViewModel.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 8.10.2024.
//


import Foundation
import RxSwift

class AnasayfaViewModel {
    var urepo = UrunlerRepository()
    var urunlerListesi = BehaviorSubject<[Urunler]>(value: [Urunler]())
    let kullaniciAdi = "buraksatir"
    
    init(){
        urunlerListesi = urepo.urunlerListesi
        urunleriYukle()
    }
    
    func urunleriYukle(){
        urepo.urunleriYukle()
    }
    
    func sepeteEkle(ad:String,resim:String,kategori:String,fiyat:Int,marka:String,siparisAdeti:Int,kullaniciAdi:String){
        urepo.sepeteEkle(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi)
    }
    
    func filtreleKategorisineGore(kategori: String) -> [Urunler] {
        guard let urunler = try? urunlerListesi.value() else { return [] }
        return urunler.filter { $0.kategori == kategori }
    }
    
    func sortByPriceAscending() -> [Urunler] {
        guard let urunler = try? urunlerListesi.value() else { return [] }
        return urunler.sorted { $0.fiyat! < $1.fiyat! }
    }
    
    func sortByPriceDescending() -> [Urunler] {
        guard let urunler = try? urunlerListesi.value() else { return [] }
        return urunler.sorted { $0.fiyat! > $1.fiyat! }
    }
    
    func sortByAlphabetAscending() -> [Urunler] {
        guard let urunler = try? urunlerListesi.value() else { return [] }
        return urunler.sorted { $0.ad! < $1.ad! }
    }
    
    func sortByAlphabetDescending() -> [Urunler] {
        guard let urunler = try? urunlerListesi.value() else { return [] }
        return urunler.sorted { $0.ad! > $1.ad! }
    }
}

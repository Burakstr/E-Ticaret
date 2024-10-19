//
//  FavorilerRepository.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 17.10.2024.
//

import RxSwift

class FavorilerRepository {
    static let shared = FavorilerRepository()  // Singleton

    // Favori ürünleri tutan BehaviorSubject
    var favorilerListesi = BehaviorSubject<[Urunler]>(value: [])
    
    private init() {}
    
    func favoriEkle(urun: Urunler) {
        var currentFavoriler = try! favorilerListesi.value()
        if !currentFavoriler.contains(where: { $0.ad == urun.ad }) {
            currentFavoriler.append(urun)
            favorilerListesi.onNext(currentFavoriler)  // Güncel listeyi yayar
        }
    }
    
    func favoriCikar(urun: Urunler) {
        var currentFavoriler = try! favorilerListesi.value()
        if let index = currentFavoriler.firstIndex(where: { $0.ad == urun.ad }) {
            currentFavoriler.remove(at: index)
            favorilerListesi.onNext(currentFavoriler)  // Güncel listeyi yayar
        }
    }
    
    func favoriDurumu(urun: Urunler) -> Bool {
        return try! favorilerListesi.value().contains(where: { $0.ad == urun.ad })
    }
}

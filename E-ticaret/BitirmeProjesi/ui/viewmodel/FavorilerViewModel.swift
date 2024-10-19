//
//  FavorilerViewModel.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 17.10.2024.
//

import Foundation
import RxSwift

class FavorilerViewModel {
    private let favorilerRepository = FavorilerRepository.shared
    let favoriler: Observable<[Urunler]>  // View'da kullanmak için Observable
    
    init() {
        // Favoriler listesini Observable'a dönüştürüyoruz
        self.favoriler = favorilerRepository.favorilerListesi.asObservable()
    }
    
    func favoriEkle(urun: Urunler) {
        favorilerRepository.favoriEkle(urun: urun)
    }
    
    func favoriCikar(urun: Urunler) {
        favorilerRepository.favoriCikar(urun: urun)
    }
    
    func favoriDurumu(urun: Urunler) -> Bool {
        return favorilerRepository.favoriDurumu(urun: urun)
    }
}

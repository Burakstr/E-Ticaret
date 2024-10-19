//
//  GirisSayfaViewModel.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 19.10.2024.
//


import Foundation
import FirebaseAuth

class GirisSayfaViewModel {

    func kullaniciGiris(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, "Giriş başarısız: \(error.localizedDescription)")
                return
            }
            completion(true, "Giriş başarılı")
        }
    }
}

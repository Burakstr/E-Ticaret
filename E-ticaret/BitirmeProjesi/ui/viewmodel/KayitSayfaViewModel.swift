//
//  KayitSayfaViewModel.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 19.10.2024.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore

class KayitSayfaViewModel {
    let db = Firestore.firestore()
    
    // Kullanıcı kaydı ve Firestore'a bilgi ekleme işlemi
    func kullaniciKayit(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, "Kayıt başarısız: \(error.localizedDescription)")
                return
            }
            
            if let userID = authResult?.user.uid {
                self.db.collection("users").document(userID).setData([
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email
                ]) { error in
                    if let error = error {
                        completion(false, "Veritabanına ekleme hatası: \(error.localizedDescription)")
                    } else {
                        completion(true, "Kayıt başarılı!")
                    }
                }
            }
        }
    }
    
    // E-mail doğrulama fonksiyonu
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

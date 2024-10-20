//
//  KayıtOlSayfa.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 15.10.2024.
//

import UIKit

class KayitSayfa: UIViewController {
 
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
 
    var viewModel = KayitSayfaViewModel()
    var isPasswordVisible = false // Şifrenin görünür olup olmadığını takip ediyoruz
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPasswordVisibilityToggle()
        
        // İlk harfleri büyük olacak şekilde ayarlıyoruz
        firstNameTextField.autocapitalizationType = .words
        lastNameTextField.autocapitalizationType = .words
    }
 
    private func setupPasswordVisibilityToggle() {
        passwordTextField.textContentType = .oneTimeCode
        let passwordToggleBtn = UIButton(type: .custom)
        passwordToggleBtn.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        passwordToggleBtn.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        passwordToggleBtn.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        passwordToggleBtn.tintColor = UIColor.gray
        passwordToggleBtn.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
     
        passwordTextField.rightView = passwordToggleBtn
        passwordTextField.rightViewMode = .always
        passwordTextField.isSecureTextEntry = true
    }
 
    @objc func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        if let button = passwordTextField.rightView as? UIButton {
            button.isSelected = isPasswordVisible
        }
    }
 
    @IBAction func registerButtonTapped(_ sender: Any) {
        // Ad ve soyadın baş harflerini büyük yap
        firstNameTextField.text = firstNameTextField.text?.capitalizeFirstLetter()
        lastNameTextField.text = lastNameTextField.text?.capitalizeFirstLetter()
        
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            showAlert(message: "Ad alanını doldurun.")
            return
        }

        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            showAlert(message: "Soyad alanını doldurun.")
            return
        }

        guard let email = emailTextField.text, !email.isEmpty, viewModel.isValidEmail(email) else {
            showAlert(message: "Geçerli bir email adresi girin.")
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Şifre alanını doldurun.")
            return
        }

        // ViewModel'e kullanıcı kaydı yapma işlemini yönlendir
        viewModel.kullaniciKayit(email: email, password: password, firstName: firstName, lastName: lastName) { [weak self] success, message in
            if success {
                self?.showAlert(message: message, completion: {
                    self?.dismiss(animated: true, completion: nil) // Kayıt başarılıysa giriş sayfasına dön
                })
            } else {
                self?.showAlert(message: message)
            }
        }
    }

    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
            completion?()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

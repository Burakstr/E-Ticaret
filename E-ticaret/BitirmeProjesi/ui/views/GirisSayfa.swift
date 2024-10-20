//
//  GirisSayfa.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 15.10.2024.
//


import UIKit

class GirisSayfa: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var viewModel = GirisSayfaViewModel()
    var isPasswordVisible = false // Şifrenin görünümü
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPasswordVisibilityToggle()
    }
    
    private func setupPasswordVisibilityToggle() {
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
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        viewModel.kullaniciGiris(email: email, password: password) { [weak self] success, message in
            if success {
                self?.transitionToHomePage()
            } else {
                self?.showAlert(message: message)
            }
        }
    }
    
    // Anasayfaya geçiş
    func transitionToHomePage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarControllerID") as? UITabBarController {
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.window?.rootViewController = tabBarVC
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

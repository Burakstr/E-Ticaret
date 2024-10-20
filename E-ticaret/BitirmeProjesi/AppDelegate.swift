//
//  AppDelegate.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 8.10.2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        // Oturum kapatma işlemi
                do {
                    try Auth.auth().signOut()
                    print("Oturum başarıyla kapatıldı.")
                } catch let signOutError as NSError {
                    print("Oturum kapatılırken hata oluştu: \(signOutError.localizedDescription)")
                }

                // Giriş Sayfasına yönlendirme (eğer storyboard kullanıyorsanız)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let loginVC = storyboard.instantiateViewController(withIdentifier: "TabBarControllerID") as? GirisSayfa {
                    window?.rootViewController = loginVC
                    window?.makeKeyAndVisible()
                }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


//
//  AppDelegate.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/4/24.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

var CoachName = UserDefaults.standard.string(forKey: "Coach_Key") ?? ""
var IsOwner = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        window = .init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        if CoachName == "" {
            window?.rootViewController = UINavigationController(rootViewController: SelectCoachViewController())
        } else {
            window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        }
        addNotification()
        return true
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeToMainViewController(_:)), name: .init("GoToMain"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeToSelectCoach), name: .init("ChangeCoach"), object: nil)
    }
    
    @objc private func ChangeToSelectCoach() {
        guard
            let window = UIApplication.shared.keyWindow
        else { return }
        UserDefaults.standard.setValue(nil, forKey: "Coach_Key")
        UserDefaults.standard.synchronize()
        CoachName = ""
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            window.rootViewController = UINavigationController(rootViewController: SelectCoachViewController())
        }, completion: { completed in
        })
    }
    
    @objc private func changeToMainViewController(_ notification: Notification) {
        guard
            let window = UIApplication.shared.keyWindow,
            let coachName = UserDefaults.standard.string(forKey: "Coach_Key")
        else { return }
        CoachName = coachName
        
        if !((notification.object as? Bool) ?? false) {
            IsOwner = false
            UserDefaults.standard.setValue(nil, forKey: "Coach_Key")
            UserDefaults.standard.synchronize()
        } else {
            IsOwner = true
        }
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            window.rootViewController = UINavigationController(rootViewController: MainViewController())
        }, completion: { completed in
        })
    }
}


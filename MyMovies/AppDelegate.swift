//
//  AppDelegate.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    customizeAppearance()
    return true
  }
  
  func customizeAppearance() {
    let navigationAppearance = UINavigationBar.appearance()
    navigationAppearance.barTintColor = UIColor.black
    navigationAppearance.titleTextAttributes = [
      NSAttributedStringKey.foregroundColor:
        Color.yellow ]
    navigationAppearance.tintColor = .white
    
    let tabBarAppearance = UITabBar.appearance()
    tabBarAppearance.barTintColor = UIColor.black.withAlphaComponent(0.8)
    tabBarAppearance.tintColor = Color.yellow
  }

}

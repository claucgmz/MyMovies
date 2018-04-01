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
    UINavigationBar.appearance().barTintColor = UIColor.black
    UINavigationBar.appearance().titleTextAttributes = [
      NSAttributedStringKey.foregroundColor:
        UIColor.white ]
    UITabBar.appearance().barTintColor = UIColor.black.withAlphaComponent(0.8)
    UITabBar.appearance().tintColor = Color.yellow
  }

}

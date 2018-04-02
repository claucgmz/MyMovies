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
    verifyAuth()
    customizeAppearance()
    return true
  }
  
    func verifyAuth() {
      var storyboard: String
      var initialViewController: String

      if AuthHandler.getCurrentAuth() != nil {
        storyboard =  StoryboardPath.main.rawValue
        initialViewController = ViewControllerPath.homeViewController.rawValue
      } else {
        storyboard =  StoryboardPath.login.rawValue
        initialViewController = ViewControllerPath.loginViewController.rawValue
      }
      initView(with: storyboard, viewControllerName: initialViewController)
    }
    
  func customizeAppearance() {
    UINavigationBar.appearance().barTintColor = UIColor.black
    UINavigationBar.appearance().titleTextAttributes = [
      NSAttributedStringKey.foregroundColor:
        UIColor.white ]
    UITabBar.appearance().barTintColor = UIColor.black.withAlphaComponent(0.8)
    let tintColor = UIColor(red: 255/255.0, green: 238/255.0,
                            blue: 136/255.0, alpha: 1.0)
    UITabBar.appearance().tintColor = tintColor
  }
    
    func initView(with storyboardName: String, viewControllerName: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as UIViewController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }

}

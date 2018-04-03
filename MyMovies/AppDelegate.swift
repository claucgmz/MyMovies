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
    AuthHandler.logOut()
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
    
    func initView(with storyboardName: String, viewControllerName: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as UIViewController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        ReachabilityManager.shared.startMonitoring()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        ReachabilityManager.shared.stopMonitoring()
    }
}

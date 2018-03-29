//
//  AppDelegate.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
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
    
    return true
  }
    
    func initView(with storyboardName: String, viewControllerName: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as UIViewController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }

}

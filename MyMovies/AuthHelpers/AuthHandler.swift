//
//  AuthHandler.swift
//  MyMovies
//
//  Created by Haydee Rodriguez on 3/28/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//
import Foundation
import Firebase
import FacebookLogin
import UIKit

struct AuthHandler {
    
    static func facebookLogin(loginVC: LoginViewController) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(readPermissions: [.publicProfile, .email], viewController: loginVC) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(grantedPermissions: _, _, let token):
                successLogin(loginVC: loginVC, token: token.authenticationToken)
            }
        }
    }
    
    static func successLogin(loginVC: LoginViewController, token: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                print("\(error)")
            }
            loginVC.changeView(with: StoryboardPath.main.rawValue, viewControllerName: ViewControllerPath.homeViewController.rawValue)
        }
    }
    
    static func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    static func getCurrentAuth() -> String? {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser!.uid
        } else {
            return nil
        }
    }
}

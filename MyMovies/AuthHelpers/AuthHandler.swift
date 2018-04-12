//
//  AuthHandler.swift
//  MyMovies
//
//  Created by Haydee Rodriguez on 3/28/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//
import Foundation
import Firebase
import FacebookCore
import FacebookLogin
import UIKit
import AlamofireImage

struct AuthHandler {
    
    static func facebookLogin(loginVC: LoginViewController) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(readPermissions: [.publicProfile, .email], viewController: loginVC) { (loginResult) in
            switch loginResult {
            case .failed:
                ErrorHandler.handle(spellError: ErrorType.notFound)
            case .cancelled:
                ErrorHandler.handle(spellError: ErrorType.loginCancel)
            case .success(grantedPermissions: _, _, let token):
                successLogin(loginVC: loginVC, token: token.authenticationToken)
            }
        }
    }
    
    static func successLogin(loginVC: LoginViewController, token: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { (_, error) in
            if let _ = error {
                ErrorHandler.handle(spellError: ErrorType.loginCancel)
            }
            loginVC.changeView(with: StoryboardPath.main.rawValue, viewControllerName: ViewControllerPath.homeViewController.rawValue)
        }
    }
    
    static func logOut(logoutVC: ProfileViewController) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            logoutVC.changeView(with: StoryboardPath.login.rawValue, viewControllerName: ViewControllerPath.loginViewController.rawValue)
        } catch _ as NSError {
            ErrorHandler.handle(spellError: ErrorType.loginCancel)
        }
    }
    
    static func getCurrentAuth() -> String? {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser!.uid
        } else {
            ErrorHandler.handle(spellError: ErrorType.connectivity)
            return nil
        }
    }
    
    static func getUserInfo(onSuccess: @escaping ([String: Any]?) -> Void, onFailure: @escaping (Error) -> Void) {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name"],
                                accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)) { _, result in
                                    switch result {
                                    case .success(let response):
                                        onSuccess(response.dictionaryValue)
                                    case .failed(let error):
                                        onFailure(error)
                                    }
        }
        connection.start()
    }
    
    static func getProviderId(for provider: String) -> String? {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            return nil
        }
        for providerInfo in providerData where providerInfo.providerID == provider {
            return providerInfo.uid
        }
        return nil
    }
    
    static func getUrlImageProfile() -> URL? {
        if let fbId = getProviderId(for: "facebook.com") {
            return URL(string: "https://graph.facebook.com/\(fbId)/picture?type=large")!
        } else {
            return nil
        }
    }
}

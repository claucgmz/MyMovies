//
//  LoginViewController+NetworkStatusListener.swift
//  MyMovies
//
//  Created by Haydee Rodriguez on 4/3/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import ReachabilitySwift

extension LoginViewController: NetworkStatusListener {
    
    func networkStatusDidChange(status: Reachability.NetworkStatus) {
        var showButton: Bool
        switch status {
        case .notReachable:
            debugPrint("ViewController: Network became unreachable")
            showButton = false
        case .reachableViaWiFi:
            debugPrint("ViewController: Network reachable through WiFi")
            showButton = true
        case .reachableViaWWAN:
            debugPrint("ViewController: Network reachable through Cellular Data")
            showButton = true
        }
        changeStatusLoginButton(status: showButton)
    }
    
    func changeStatusLoginButton(status: Bool) {
        let message = "You dont have conectitity"
        DispatchQueue.main.async {
            self.loginButton.isEnabled = status
            let alert = UIAlertController(title: "Network connectivity", message: message, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

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
        
        switch status {
        case .notReachable:
            debugPrint("ViewController: Network became unreachable")
        case .reachableViaWiFi:
            debugPrint("ViewController: Network reachable through WiFi")
        case .reachableViaWWAN:
            debugPrint("ViewController: Network reachable through Cellular Data")
        }
        
        // Update login button Enable/Disable status
        DispatchQueue.main.async { 
            self.loginButton.isEnabled = !(status == .notReachable)
        }
    }
}

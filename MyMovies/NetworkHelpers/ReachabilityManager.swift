//
//  ReachabilityManager.swift
//  MyMovies
//
//  Created by Haydee Rodriguez on 4/3/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import ReachabilitySwift
import NotificationBannerSwift

public protocol NetworkStatusListener: class {
    func networkStatusDidChange(status: Reachability.NetworkStatus)
}

class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()
    
    var isNetworkAvailable: Bool {
        return reachabilityStatus != .notReachable
    }
    
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    
    let reachability = Reachability()!
    
    var listeners = [NetworkStatusListener]()
    
    /// Called whenever there is a change in NetworkReachibility Status
    /// — parameter notification: Notification with the Reachability instance
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = (notification.object as? Reachability)!
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            debugPrint("Network became unreachable")
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "Network", subtitle: "You don't have conectivity", style: .danger)
                banner.show()
            }
        case .reachableViaWiFi:
            debugPrint("Network reachable through WiFi")
        case .reachableViaWWAN:
            debugPrint("Network reachable through Cellular Data")
        }
        
        // Sending message to each of the delegates
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.currentReachabilityStatus)
        }
    }

    func startMonitoring() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification,
                                                  object: reachability)
    }
    
    /// Adds a new listener to the listeners array
    /// - parameter delegate: a new listener
    func addListener(listener: NetworkStatusListener) {
        listeners.append(listener)
    }
    
    /// Removes a listener from listeners array
    /// - parameter delegate: the listener which is to be removed
    func removeListener(listener: NetworkStatusListener) {
        listeners = listeners.filter { $0 !== listener}
    }
}

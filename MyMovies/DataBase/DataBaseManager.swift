//
//  DataBaseManager.swift
//  MyMovies
//
//  Created by Haydee Rodriguez on 3/23/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class DataBaseManager {
    static let shared = DataBaseManager()
    
    func getUser(onSuccess: @escaping (Dictionary<String,String>) -> Void, onFailure: @escaping (Error?) -> Void) {
        DataBaseService.shared.usersRef.observeSingleEvent(of: .value) { snapshot in
            if let user = snapshot.value as? Dictionary<String,String> {
                onSuccess(user)
            }
        }
    }
}

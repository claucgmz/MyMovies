//
//  DataBaseService.swift
//  MyMovies
//
//  Created by Haydee Rodriguez on 3/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DataBaseService {
    
    private static let _shared = DataBaseService()
    private let usersDataBase = "users"
    
    static var shared: DataBaseService {
        return _shared
    }
    
    var mainRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var usersRef: DatabaseReference {
        return mainRef.child(usersDataBase)
    }
}

//
//  File.swift
//  MyMovies
//
//  Created by Haydee Rodriguez on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class User {
    var id = ""
    var email = ""
    var facebookId = ""
    
    var imageURL: URL {
        return URL(string: "https://graph.facebook.com/\(facebookId)/picture?type=large")!
    }
    
    init(id: String, email: String, facebookId: String) {
        self.id = id
        self.email = email
        self.facebookId = facebookId
    }
}


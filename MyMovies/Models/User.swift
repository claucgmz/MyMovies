//
//  File.swift
//  MyMovies
//
//  Created by Haydee Rodriguez on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    
    var id = ""
    var email = ""
    var facebookId = ""
    
    var imageURL: URL {
        return URL(string: "https://graph.facebook.com/\(facebookId)/picture?type=large")!
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        email <- map["email"]
        facebookId <- map["facebookId"]
    }
    
}


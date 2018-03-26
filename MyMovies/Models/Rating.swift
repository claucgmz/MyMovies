//
//  Rating.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/25/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import ObjectMapper

struct Rating: Mappable, DBModel {
  var id: String = ""
  var stars: Int = 0
  
  init(id: String, stars: Int) {
    self.id = id
    self.stars = stars
  }
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    id          <- map["id"]
    stars       <- map["stars"]
  }
  
  func toDictionary() -> [String: Any] {
    return [
      "stars": stars
    ]
  }
  
}

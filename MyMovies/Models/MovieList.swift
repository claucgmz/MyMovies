//
//  MovieList.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/22/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import ObjectMapper

struct MovieList: Mappable {
  var id = UUID().uuidString
  var name = ""
  var moviesIds = [Int]()
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    id        <- map["id"]
    name      <- map["name"]
    moviesIds <- map["moviesIds"]
  }

  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "name": name,
      //"icon": icon.rawValue,
      "movieIds": moviesIds
    ]
  }
}

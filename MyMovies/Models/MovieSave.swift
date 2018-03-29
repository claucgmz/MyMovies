//
//  MovieSave.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/27/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import ObjectMapper

struct MovieSave: DBModel, Mappable {  
  var id: String = ""
  var lists = [String: Bool]()
  var movieBrief: MovieBrief?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    id         <- map["id"]
    lists      <- map["lists"]
    movieBrief <- map["movieBrief"]
  }
  
  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "lists": lists,
      "movieBrief": movieBrief?.toDictionary ?? [:]
    ]
  }
}

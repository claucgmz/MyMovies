//
//  MovieBrief.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import ObjectMapper

struct MovieBrief: DBModel, Mappable {
  var id = ""
  var title = ""
  var posterPath = ""
  
  init?(map: Map) {
  }
  
  init(id: String, title: String, posterPath: String) {
    self.id = id
    self.title = title
    self.posterPath = posterPath
  }
  
  mutating func mapping(map: Map) {
    id         <- map["id"]
    title      <- map["title"]
    posterPath <- map["poster_path"]
  }
  
  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "title": title,
      "poster_path": posterPath
    ]
  }
}

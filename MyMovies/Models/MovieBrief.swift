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
  var rating = 0
  
  init?(map: Map) {
  }
  
  init(id: String, title: String, posterPath: String) {
    self.id = id
    self.title = title
    self.posterPath = posterPath
  }
  
  mutating func mapping(map: Map) {
    id         <- map["brief.id"]
    title      <- map["brief.title"]
    posterPath <- map["brief.poster_path"]
    rating     <- map["rating"]
  }
  
  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "title": title,
      "poster_path": posterPath
    ]
  }
}

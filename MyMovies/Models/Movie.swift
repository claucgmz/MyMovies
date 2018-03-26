//
//  Movie.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import ObjectMapper

struct Movie: Mappable {
  var id: Int!
  var title: String!
  var posterPath = ""
  var sinopsis: String!
  var releaseDate = Date()
  
  init?(map: Map) {

  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    title <- map["title"]
    posterPath <- map["poster_path"]
    sinopsis <- map["overview"]
    releaseDate <- (map["releaseDate"], DateTransform())
  }
}

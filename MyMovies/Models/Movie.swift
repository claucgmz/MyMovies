//
//  Movie.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import ObjectMapper

struct Movie: Mappable, SearchResult {
  var id = 0
  var title = ""
  var posterPath = ""
  var backPath = ""
  var sinopsis = ""
  var releaseDate = Date()
  var genres = [Genre]()
  var runtime = 0
  var tagline = ""
  var status = ""
  
  var idString: String {
    return String(id)
  }
  var genresString: String {
    return genres.reduce("", { text, genre in
      return text + genre.description + " | "
    })
  }
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    id          <- map["id"]
    title       <- map["title"]
    posterPath  <- map["poster_path"]
    backPath    <- map["backdrop_path"]
    sinopsis    <- map["overview"]
    releaseDate <- (map["releaseDate"], DateTransform())
    genres      <- (map["genre_ids"], EnumTransform<Genre>())
    runtime     <- map["runtime"]
    tagline     <- map["tagline"]
    status      <- map["status"]
  }
}

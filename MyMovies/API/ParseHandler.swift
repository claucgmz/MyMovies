//
//  ParseHandler.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/25/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import PromiseKit
import ObjectMapper

struct ParseHandler {
  static func parseMovie(with data: [String: Any]) -> Promise <Movie> {
    return Promise { fulfill, reject in
      guard let movie = Mapper<Movie>().map(JSON: data) else {
        return
      }
      fulfill(movie)
    }
  }
  
  static func parseMovies(with data: [String: Any]) -> Promise <[Movie]> {
    return Promise { fulfill, reject in
      guard let results = data["results"] as? [[String: Any]] else {
        return
      }
      
      let movies = Mapper<Movie>().mapArray(JSONArray: results)
      fulfill(movies)
    }
  }
}

//
//  MyMoviesService.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import ObjectMapper
import PromiseKit

struct MyMoviesService {
  static func getMovies(for type: MovieType, page: Int = 1) -> Promise<[Movie]> {
    return MyMoviesRepository.getMovies(for: type, page: page)
      .then(execute: { json -> [Movie] in
        guard let results = json["results"] as? [[String: Any]] else {
          return []
        }
        
        let movies = Mapper<Movie>().mapArray(JSONArray: results)
        return movies
      })
  }
  
}

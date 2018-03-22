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
  
  static func getMovie(with id: Int) -> Promise<Movie?> {
    return MyMoviesRepository.getMovie(with: id)
      .then(execute: { json -> Movie? in
        guard let movie = Mapper<Movie>().map(JSON: json) else {
          return nil
        }
        return movie
      })
  }
  
  static func getUserMovieLists() -> Promise<[MovieList]> {
    return MyMoviesRepository.getUserMovieLists()
    .then(execute: { json -> [MovieList] in
      let movies = Mapper<MovieList>().mapArray(JSONArray: json)
      return movies
    })
  }
  
  static func getUserRating(for movieId: Int) -> Promise<Int?> {
    return MyMoviesService.getUserRating(for: movieId)
    .then(execute: { rating -> Int? in
      guard let rating = rating else {
        return 0
      }
      
      return rating
    })
  }
  
}

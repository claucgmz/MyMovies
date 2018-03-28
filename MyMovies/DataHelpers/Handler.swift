//
//  Handler.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/25/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import PromiseKit

struct Handler {
  static func getMovie(withId id: String) -> Promise <Movie?> {
    return APIHandler.getMovie(withId: id).then(execute: { data -> Movie? in
      guard let movie = ParseHandler.parseMovie(with: data) else {
        return nil
      }
      return movie
    })
  }
  
  static func getMovies(for type: MovieType, page: Int = 1) -> Promise <[Movie]> {
    return APIHandler.getMovies(for: type, page: page).then(execute: { data -> [Movie] in
      return ParseHandler.parseMovies(with: data)
    })
  }
  
  static func getRating(for id: String) -> Promise <Rating?> {
    return DBHandler.getRating(for: id).then(execute: { data -> Rating? in
      return ParseHandler.parseRating(with: data)
    })
  }
  
  static func getLists() -> Promise <[MovieList]> {
    return DBHandler.getLists().then(execute: { data -> [MovieList] in
      return ParseHandler.parseMovieLists(with: data)
    })
  }
  
  static func getMovieData(withId id: String) -> Promise <MovieSave?> {
    return DBHandler.getMovieData(withId: id).then(execute: { data -> MovieSave? in
      return ParseHandler.parseMovieSave(with: data)
    })
  }
}

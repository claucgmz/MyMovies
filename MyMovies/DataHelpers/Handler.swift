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
    return APIHandler.getMovie(withId: id).map { data -> Movie? in
      guard let movie = ParseHandler.parseMovie(with: data) else {
        return nil
      }
      return movie
    }
  }
    
  static func getMovies(for type: MovieType, page: Int = 1) -> Promise <PaginatedResponse> {
      return APIHandler.getMovies(for: type, page: page).map { data -> PaginatedResponse in
          return ParseHandler.parsePaginatedResponse(with: data)
      }
  }
  
  static func searchMovies(by name: String, page: Int = 1) -> Promise <PaginatedResponse> {
    return APIHandler.searchMovies(by: name, page: page).map { data -> PaginatedResponse in
      return ParseHandler.parsePaginatedResponse(with: data)
    }
  }
  
  static func getMoviesByGenre(by genre: Int, page: Int = 1) -> Promise <PaginatedResponse> {
    return APIHandler.getMoviesByGenre(by: genre, page: page).map { data -> PaginatedResponse in
      return ParseHandler.parsePaginatedResponse(with: data)
    }
  }
  
  static func getRating(for id: String) -> Promise <Int> {
    return DBHandler.getRating(for: id).map { data in
      return data
    }
  }
  
  static func getLists() -> Promise <[MovieList]> {
    return DBHandler.getLists().map { data -> [MovieList] in
      return ParseHandler.parseMovieLists(with: data)
    }
  }
  
  static func getMovieLists(for movieId: String) -> Promise <[String]> {
    return DBHandler.getMovieLists(for: movieId).map { data -> [String] in
      return ParseHandler.parseDictionaryKeysToArray(with: data)
    }
  }
  
  static func getMovies(forList listId: String) -> Promise <[MovieBrief]> {
    return DBHandler.getMovies(for: listId).map { data -> [MovieBrief] in
      return ParseHandler.parseMovieBrief(with: data)
    }
  }
  
}

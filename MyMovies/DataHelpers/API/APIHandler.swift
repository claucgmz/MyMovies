//
//  APIHandler.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/25/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

struct APIHandler {
  static let sessionManager = Server.manager
  
  static func getMovies(for type: MovieType, page: Int = 1) -> Promise <[String: Any]> {
    return Promise { resolve in
      sessionManager.request(MyMoviesRouter.getMovies(type: type, page: page))
        .validate()
        .responseJSON(completionHandler: { response in
          if let json = response.result.value as? [String: Any] {
            resolve.fulfill(json)
          } else if let error = response.error {
            resolve.reject(error)
          }
        })
    }
  }
  
  static func getMovie(withId id: String) -> Promise <[String: Any]> {
    return Promise { resolve in
      sessionManager.request(MyMoviesRouter.getMovie(id: id))
        .validate()
        .responseJSON(completionHandler: { response in
          if let json = response.result.value as? [String: Any] {
            resolve.fulfill(json)
          } else if let error = response.error {
            resolve.reject(error)
          }
        })
    }
  }
  
  static func searchMovies(by name: String, page: Int = 1) -> Promise <[String: Any]> {
    return Promise { resolve in
        sessionManager.request(MyMoviesRouter.searchMovie(name: name, page: page))
        .validate()
        .responseJSON(completionHandler: { response in
          if let json = response.result.value as? [String: Any] {
            resolve.fulfill(json)
          } else if let error = response.error {
            resolve.reject(error)
          }
        })
    }
  }
  
  static func getMoviesByGenre(by genreId: Int, page: Int = 1) -> Promise <[String: Any]> {
    return Promise { resolve in
      sessionManager.request(MyMoviesRouter.getMoviesByGenre(genreId: genreId, page: page))
        .validate()
        .responseJSON(completionHandler: { response in
          if let json = response.result.value as? [String: Any] {
            resolve.fulfill(json)
          } else if let error = response.error {
            resolve.reject(error)
          }
        })
    }
  }
}

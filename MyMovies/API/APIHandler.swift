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
  static func getRequest(for type: MovieType, page: Int) -> URLRequestConvertible {
    switch type {
    case .featured:
      return MyMoviesRouter.getFeatured(page: page)
    case .upcoming:
      return MyMoviesRouter.getUpcoming(page: page)
    }
  }
  
  static func getMovies(for type: MovieType, page: Int = 1) -> Promise <[String: Any]> {
    return Promise { fulfill, reject in
      Alamofire.request(getRequest(for: type, page: page))
        .validate()
        .responseJSON(completionHandler: { response in
          if let json = response.result.value as? [String: Any] {
            fulfill(json)
          } else if let error = response.error {
            reject(error)
          }
        })
    }
  }
  
  static func getMovie(with id: Int) -> Promise <[String: Any]> {
    return Promise { fulfill, reject in
      Alamofire.request(MyMoviesRouter.getMovie(id: id))
        .validate()
        .responseJSON(completionHandler: { response in
          if let json = response.result.value as? [String: Any] {
            fulfill(json)
          } else if let error = response.error {
            reject(error)
          }
        })
    }
  }
}


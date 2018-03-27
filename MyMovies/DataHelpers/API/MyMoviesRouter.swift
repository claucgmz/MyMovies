//
//  MyMoviesRouter.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Alamofire

enum MyMoviesRouter: URLRequestConvertible {

  case getFeatured(page: Int)
  case getUpcoming(page: Int)
  case getMovie(id: String)
  case getMovies(type: MovieType, page: Int)
  
  var path: String {
    switch self {
    case .getFeatured:
      return "/movie/popular"
    case .getUpcoming:
      return "/movie/upcoming"
    case .getMovie(let id):
      return "/movie/\(id)"
    case .getMovies(let type, _):
      switch type {
      case .upcoming:
        return "/movie/upcoming"
      case .featured:
        return "/movie/popular"
      }
    }
  }
  
  var parameters: [String: Any] {
    switch self {
    case .getFeatured(let page):
      return ["page": page, "api_key": APIManager.APIkey]
    case .getUpcoming(let page):
      return ["page": page, "api_key": APIManager.APIkey]
    case .getMovie:
      return ["api_key": APIManager.APIkey]
    case .getMovies(_, let page):
      return ["page": page, "api_key": APIManager.APIkey]
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .getFeatured, .getUpcoming, .getMovie, .getMovies:
      return .get
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try APIManager.baseURLString.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    print(url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    return try URLEncoding.methodDependent.encode(urlRequest, with: parameters)
  }
}

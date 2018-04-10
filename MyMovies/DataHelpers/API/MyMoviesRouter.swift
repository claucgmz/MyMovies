//
//  MyMoviesRouter.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Alamofire

enum MyMoviesRouter: URLRequestConvertible {
  case getMovie(id: String)
  case getMovies(type: MovieType, page: Int)
  case searchMovie(name: String, page: Int)
  case getMoviesByGenre(genreId: Int, page: Int)
  
  var path: String {
    switch self {
    case .getMovie(let id):
      return "/movie/\(id)"
    case .getMovies(let type, _):
      switch type {
      case .upcoming:
        return "/movie/upcoming"
      case .featured:
        return "/movie/popular"
      }
    case .searchMovie:
        return "/search/movie"
    case .getMoviesByGenre(let genreId, _):
      return "/genre/\(genreId)/movies"
  
    }
  }
  
  var parameters: [String: Any] {
    var parameters: [String: Any] = [:]
    switch self {
    case .getMovie:
      parameters = [:]
    case .getMovies(_, let page):
      parameters = ["page": page]
    case .searchMovie(let name, let page):
        parameters = ["query": name, "page": page]
    case .getMoviesByGenre(_, let page):
      parameters = ["page": page]
    }
    parameters["api_key"] = APIManager.APIkey
    return parameters
  }
  
  var method: HTTPMethod {
    switch self {
    case .getMovie, .getMovies, .searchMovie, .getMoviesByGenre:
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

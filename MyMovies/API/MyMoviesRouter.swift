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
  
  var path: String {
    switch self {
    case .getFeatured:
      return "/movie/popular"
    case .getUpcoming:
      return "/movie/upcoming"
    }
  }
  
  var parameters: [String: Any] {
    switch self {
    case .getFeatured(let page):
      return ["page": page, "api_key": APIManager.APIkey]
    case .getUpcoming(let page):
      return ["page": page, "api_key": APIManager.APIkey]
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .getFeatured, .getUpcoming:
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

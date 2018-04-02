//
//  Server.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/30/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import Alamofire

struct Server {
  static var manager: SessionManager {
    var headers = Alamofire.SessionManager.defaultHTTPHeaders
    headers["api_key"] = APIManager.APIkey
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = headers
    return Alamofire.SessionManager(configuration: configuration)
  }
}

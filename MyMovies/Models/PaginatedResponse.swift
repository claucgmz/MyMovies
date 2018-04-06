//
//  PaginatedResponse.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 4/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import ObjectMapper

struct PaginatedResponse: Mappable {
  var currentPage = 1
  var totalPages = 1
  var results = [Movie]()
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    currentPage <- map["page"]
    totalPages  <- map["total_pages"]
    results     <- map["results"]
  }
}

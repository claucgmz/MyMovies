//
//  MovieList.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/22/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

struct MovieList: DBModel {
  var id = UUID().uuidString
  var name = ""
  var movies = [MovieBrief]()
  
  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "name": name,
      "movie": movies
    ]
  }
}

//
//  MovieList.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/22/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

struct MovieList {
  var id = UUID().uuidString
  var name = ""
  var moviesIds = [Int]()
  
  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "name": name,
      //"icon": icon.rawValue,
      "movieIds": moviesIds
    ]
  }
}

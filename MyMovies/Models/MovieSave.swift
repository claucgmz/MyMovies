//
//  MovieSave.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/27/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

struct MovieSave: DBModel {
  var id: String
  var lists = [String]()
  var movieBrief: MovieBrief?
  
  func toDictionary() -> [String : Any] {
    return [
      "id": id
    ]
  }
  
}

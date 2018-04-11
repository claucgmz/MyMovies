//
//  MovieList.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/22/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import ObjectMapper

struct MovieList: DBModel, Mappable {
  var id = UUID().uuidString
  var name = "No name"
  var movies = [MovieBrief]()
  
  static var watchedListId = FirebasePath.watched.rawValue

  init?(map: Map) {
    
  }
  
  init(name: String) {
    self.name = name
  }
  
  mutating func mapping(map: Map) {
    id           <- map["id"]
    name         <- map["name"]
    var movies = [MovieBrief]()
    movies       <- map["movies"]
    self.movies = movies
  }
  
  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "name": name,
      "movie": movies
    ]
  }
  
  static func getWatchedList() -> MovieList {
    var movieList = MovieList(name: "Movies you already watched")
    movieList.id = watchedListId
    return movieList
  }
}

//
//  DBHandler.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/25/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import FirebaseDatabase
import PromiseKit

struct DBHandler {
  static let movielistsRef = Database.database().reference(withPath: FirebasePath.lists.rawValue)
  static let ratingsRef = Database.database().reference(withPath: FirebasePath.ratings.rawValue)
  static let moviesRef = Database.database().reference(withPath: FirebasePath.movies.rawValue)
  
  static func getLists() -> Promise <[[String: Any]]> {
    return Promise { fullfill, _ in
      movielistsRef.observe(.value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        var movielistDictArray: [[String: Any]] = []
        for snData in data {
          if let movieListData = snData.value as? [String: Any] {
            movielistDictArray.append(movieListData)
          }
        }
        fullfill(movielistDictArray)
      })
    }
  }

  static func getMovies(for listId: String)  -> Promise <[String: Any]> {
    return Promise { fulfill, _ in
      moviesRef.queryOrdered(byChild: "lists/"+listId).queryEqual(toValue: true).observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        fulfill(data)
      })
    }
  }

  static func getMovieLists(for movieId: String) -> Promise <[String: Any]> {
    return Promise { fullfill, _ in
      moviesRef.child(movieId).child(FirebasePath.lists.rawValue).observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        fullfill(data)
      })
    }
  }
  
  static func saveMovieList(for movieId: String, lists: [String]) {
      return moviesRef.child(movieId).child(FirebasePath.lists.rawValue).setValue(lists.toDictionary(with: { _ in
        return true
      }))
  }
  
  static func saveList(_ list: DBModel) {
    movielistsRef.child(list.id).setValue(list.toDictionary())
  }
  
  static func removeList(_ list: DBModel ) {
    movielistsRef.child(list.id).removeValue()
  }
  
  static func getRating(for movieId: String) -> Promise <[String: Any]> {
    return Promise { fullfill, _ in
      ratingsRef.child(movieId).observeSingleEvent(of: .value, with: { snapshot in
        var data = snapshot.value as? [String: Any] ?? [:]
        data["id"] = movieId
        fullfill(data)
      })
    }
  }
  
  static func setRating(_ rating: DBModel) {
    ratingsRef.child(rating.id).setValue(rating.toDictionary())
  }
  
  static func getMovieData(withId id: String) -> Promise <[String: Any]> {
    return Promise { fullfill, _ in
      moviesRef.child(id).observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        fullfill(data)
      })
    }
  }
  
  
}

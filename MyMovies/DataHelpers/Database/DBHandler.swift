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
  static let ratingsRef = Database.database().reference(withPath: FirebasePath.rating.rawValue)
  static let moviesRef = Database.database().reference(withPath: FirebasePath.movies.rawValue)
  static let briefRef = Database.database().reference(withPath: FirebasePath.brief.rawValue)
  
  static func getLists() -> Promise <[[String: Any]]> {
    return Promise { resolve in
      movielistsRef.observe(.value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        var movielistDictArray: [[String: Any]] = []
        for snData in data {
          if let movieListData = snData.value as? [String: Any] {
            movielistDictArray.append(movieListData)
          }
        }
        resolve.fulfill(movielistDictArray)
      })
    }
  }
  
  static func getMovies(for listId: String) -> Promise <[[String: Any]]> {
    return Promise { resolve in
      moviesRef.queryOrdered(byChild: "lists/"+listId).queryEqual(toValue: true).observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        var movieDictArray: [[String: Any]] = []
        for snData in data {
          if let movieData = snData.value as? [String: Any] {
            movieDictArray.append(movieData)
          }
        }
        resolve.fulfill(movieDictArray)
      })
    }
  }
  
  static func getMovieLists(for movieId: String) -> Promise <[String: Any]> {
    return Promise { resolve in
      moviesRef.child(movieId).child(FirebasePath.lists.rawValue).observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        resolve.fulfill(data)
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
  
  static func getRating(for movieId: String) -> Promise <Int> {
    return Promise { resolve in
      moviesRef.child(movieId).child(FirebasePath.rating.rawValue).observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? Int ?? 0
        resolve.fulfill(data)
      })
    }
  }
  
  static func setRating(for movieId: String, rating: Int) {
    moviesRef.child(movieId).child(FirebasePath.rating.rawValue).setValue(rating)
  }
  
  static func getMovieData(withId id: String) -> Promise <[String: Any]> {
    return Promise { resolve in
      moviesRef.child(id).observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        resolve.fulfill(data)
      })
    }
  }
  
  static func saveMovieBrief(_ movieBrief: MovieBrief) {
    moviesRef.child(movieBrief.id).child(FirebasePath.brief.rawValue).setValue(movieBrief.toDictionary())
  }
}

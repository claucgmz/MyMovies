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
  
  static func getLists() -> Promise <[[String: Any]]> {
    return Promise { fullfill, reject in
      movielistsRef.observe(.value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        var movielistDictArray: [[String: Any]] = []
        for snData in data {
          if let movieData = snData.value as? [String: Any] {
            movielistDictArray.append(movieData)
          }
        }
        
        fullfill(movielistDictArray)
      })
    }
  }
  
  static func getList(with id: String) -> Promise <[String: Any]> {
    return Promise { fulfill, reject in
      movielistsRef.child(id).observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        fulfill(data)
      })
    }
  }
  
  static func updateList(with id: String, dataArray: [String: Any]) {
    movielistsRef.child(id).setValue(dataArray)
  }
  
  static func removeList(with id: String) {
    movielistsRef.child(id).removeValue()
  }
  
  static func getRating(with movieId: String) -> Promise <Int> {
    return Promise { fullfill, reject in
      ratingsRef.child(movieId).observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? Int ?? 0
        fullfill(data)
      })
    }
  }
  
  static func setRating(for movieId: String, rating: Int) {
    ratingsRef.child(movieId).setValue(rating)
  }
}

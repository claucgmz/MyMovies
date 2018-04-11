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
  
  /// Connection handler to get lists by user
  ///
  /// - Parameters:
  ///  None
  /// - Returns: a **Promise** which returns a Dictionary from database
  static func getLists() -> Promise <[[String: Any]]> {
    return Promise { resolve in
      guard let userId = AuthHandler.getCurrentAuth() else {
        return
      }
      
      movielistsRef.child(userId).observe(.value, with: { snapshot in
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
  
  /// Connection handler to get movies for specific list
  ///
  /// - Parameters:
  ///  - listId: String
  /// - Returns: a **Promise** which returns a Dictionary from database
  static func getMovies(for listId: String) -> Promise <[[String: Any]]> {
    return Promise { resolve in
      guard let userId = AuthHandler.getCurrentAuth() else {
        return
      }
      let userListPath = "\(FirebasePath.lists.rawValue)/\(userId)/\(listId)"
      moviesRef.queryOrdered(byChild: userListPath)
        .queryEqual(toValue: true)
        .observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        var movieDictArray: [[String: Any]] = []
        for snData in data {
          if var movieData = snData.value as? [String: Any] {
            if let rating = movieData["rating"] as? [String: Any] {
              movieData["rating"] = rating[userId]
            }
            movieDictArray.append(movieData)
          }
        }
        resolve.fulfill(movieDictArray)
      })
    }
  }
  
  /// Connection handler to get lists which contain a specific movie
  ///
  /// - Parameters:
  ///  - movieId: String
  /// - Returns: a **Promise** which returns a Dictionary from database
  static func getMovieLists(for movieId: String) -> Promise <[String: Any]> {
    return Promise { resolve in
      guard let userId = AuthHandler.getCurrentAuth() else {
        return
      }
      moviesRef.child(movieId)
        .child(FirebasePath.lists.rawValue)
        .child(userId)
      .observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        resolve.fulfill(data)
      })
    }
  }
  
  /// Connection handler to save lists where movie contained
  ///
  /// - Parameters:
  ///  - movieId: String
  ///  - lists: [String]
  /// - Returns: Nothing
  static func saveMovieList(for movieId: String, lists: [String]) {
    guard let userId = AuthHandler.getCurrentAuth() else {
      return
    }
    moviesRef.child(movieId)
      .child(FirebasePath.lists.rawValue)
      .child(userId)
      .setValue(lists.toDictionary(with: { _ in
        return true
      }))
  }
  
  /// Connection handler to add/edit list
  ///
  /// - Parameters:
  ///  - list: DBModel MovieList Object
  /// - Returns: Nothing
  static func saveList(_ list: DBModel) {
    guard let userId = AuthHandler.getCurrentAuth() else {
      return
    }
    movielistsRef.child(userId).child(list.id).setValue(list.toDictionary())
    let userListPath = "\(FirebasePath.lists.rawValue)/\(userId)/\(list.id)"
    moviesRef.queryOrdered(byChild: userListPath)
      .queryEqual(toValue: true)
      .observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        for snData in data {
          if let movieData = snData.value as? [String: Any] {
            print (movieData)
          }
        }
    })
  }
  
  /// Connection handler to remove list completely
  ///
  /// - Parameters:
  ///  - list: DBModel MovieList Object
  /// - Returns: Nothing
  static func removeList(_ list: DBModel ) {
    guard let userId = AuthHandler.getCurrentAuth() else {
      return
    }
    movielistsRef.child(userId)
      .child(list.id)
      .removeValue()
    let userListPath = "\(FirebasePath.lists.rawValue)/\(userId)/\(list.id)"
    moviesRef.queryOrdered(byChild: userListPath)
      .queryEqual(toValue: true)
      .observeSingleEvent(of: .value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        for snData in data {
          moviesRef.child(snData.key)
            .child(FirebasePath.lists.rawValue)
            .child(userId)
            .child(list.id)
            .removeValue()
        }
    })
  }
  
  /// Connection handler to remove movie from list
  ///
  /// - Parameters:
  ///  - movieId: String
  ///  - listId: String
  /// - Returns: Nothing
  static func removeMovie(withId movieId: String, from listId: String) {
    guard let userId = AuthHandler.getCurrentAuth() else {
      return
    }
    moviesRef.child(movieId)
      .child(FirebasePath.lists.rawValue)
      .child(userId)
      .child(listId)
      .removeValue()
  }
  
  /// Connection handler to get user rating for movie
  ///
  /// - Parameters:
  ///  - movieId: String
  /// - Returns: a **Promise** which returns a Int value
  static func getRating(for movieId: String) -> Promise <Int> {
    return Promise { resolve in
      guard let userId = AuthHandler.getCurrentAuth() else {
        return
      }
      moviesRef.child(movieId)
        .child(FirebasePath.rating.rawValue)
        .child(userId)
        .observeSingleEvent(of: .value, with: { snapshot in
          let data = snapshot.value as? Int ?? 0
          resolve.fulfill(data)
      })
    }
  }
  
  /// Connection handler to save user rating for movie
  ///
  /// - Parameters:
  ///  - movieId: String
  ///  - rating: Int
  /// - Returns: Nothing
  static func setRating(for movieId: String, rating: Int) {
    guard let userId = AuthHandler.getCurrentAuth() else {
      return
    }
    moviesRef.child(movieId)
      .child(FirebasePath.rating.rawValue)
      .child(userId)
      .setValue(rating)
  }
  
  /// Connection handler to save movie brief
  ///
  /// - Parameters:
  ///  - movieBrief: Object MovieBrief
  /// - Returns: Nothing
  static func saveMovieBrief(_ movieBrief: MovieBrief) {
    moviesRef.child(movieBrief.id)
      .child(FirebasePath.brief.rawValue)
      .setValue(movieBrief.toDictionary())
  }
  
  /// Connection handler to check if movie has been watched
  ///
  /// - Parameters:
  ///  - movieId: String
  /// - Returns: Nothing
  
  static func isMovieWatched(movieId: String) -> Promise <Bool> {
    return Promise { resolve in
      guard let userId = AuthHandler.getCurrentAuth() else {
        return
      }
      moviesRef.child(movieId)
        .child(FirebasePath.lists.rawValue)
        .child(userId)
        .child(FirebasePath.watched.rawValue)
        .observeSingleEvent(of: .value, with: { snapshot in
          let data = snapshot.value as? Bool ?? false
          resolve.fulfill(data)
        })
    }
  }
  
  /// Connection handler to set if movie has been watched
  ///
  /// - Parameters:
  ///  - movieId: String
  ///  - watched: Bool
  /// - Returns: Nothing
  static func setMovieWatched(movieId: String, watched: Bool) {
    guard let userId = AuthHandler.getCurrentAuth() else {
      return
    }
    
    let watchRef = moviesRef.child(movieId)
      .child(FirebasePath.lists.rawValue)
      .child(userId)
      .child(FirebasePath.watched.rawValue)
    
    if watched {
      watchRef.setValue(true)
    } else {
      watchRef.removeValue()
    }
  }
}

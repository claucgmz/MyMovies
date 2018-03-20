//
//  MovieCollectionView.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class MovieCollectionView {
  var type: MovieType = .featured
  var movies = [Movie]()
  
  init(type: MovieType, movies: [Movie]) {
    self.type = type
    self.movies = movies
  }
}

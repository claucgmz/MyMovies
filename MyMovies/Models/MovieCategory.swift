//
//  MovieCategory.swift
//  MyMovies
//
//  Created by Haydee Rodriguez on 4/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class MovieCategory {
    var name: String?
    var movies: [Movie]?
    
    init(name: MovieType, movies: [Movie]) {
        self.movies = movies
        self.name = "The best \(name) movies"
    }
}

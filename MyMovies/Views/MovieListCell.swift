//
//  MovieListCell.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/22/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class MovieListCell: UITableViewCell {
  @IBOutlet private weak var listNameLabel: UILabel!
  @IBOutlet private weak var totalMoviesLabel: UILabel!
  
  func configure(with movieList: MovieList) {
    listNameLabel.text = movieList.name
    totalMoviesLabel.text = "\(movieList.moviesIds.count) movies"
  }
}

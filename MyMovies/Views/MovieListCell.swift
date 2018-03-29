//
//  MovieListCell.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/22/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import SwipeCellKit

class MovieListCell: SwipeTableViewCell {
  @IBOutlet private weak var listNameLabel: UILabel!
  @IBOutlet private weak var totalMoviesLabel: UILabel!

  func configure(with movieList: MovieList, delegate: SwipeTableViewCellDelegate) {
    listNameLabel.text = movieList.name
    totalMoviesLabel.text = "\(movieList.movies.count) movies"
    self.delegate = delegate
  }
}

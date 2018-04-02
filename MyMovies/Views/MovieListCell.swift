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
  
  func configure(with movieList: MovieList, delegate: SwipeTableViewCellDelegate) {
    listNameLabel.text = movieList.name
    self.delegate = delegate
  }
}

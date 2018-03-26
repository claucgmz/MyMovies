//
//  MovieCell.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import SwipeCellKit

class MovieCell: SwipeTableViewCell {
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var posterImage: UIImageView!
  
  func configure(with movie: MovieBrief, delegate: SwipeTableViewCellDelegate) {
    titleLabel.text = movie.title
    if let url = URL(string: APIManager.baseImageURLthumbnail+movie.posterPath) {
      posterImage.af_setImage(withURL: url)
    }
    self.delegate = delegate
  }
}

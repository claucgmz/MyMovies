//
//  MovieCollectionCell.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCollectionCell: UICollectionViewCell {
  @IBOutlet private weak var movieImage: UIImageView!
  func configure(with movie: Movie) {
    if let url = URL(string: APIManager.baseImageURL+movie.posterPath) {
      movieImage.af_setImage(withURL: url)
    }
    self.layer.cornerRadius = 8.0
  }
}

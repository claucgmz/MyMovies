//
//  GenreCell.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 4/9/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class GenreCell: UICollectionViewCell {
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var genreLabel: UILabel!
  
  func configure(genre: Genre) {
    genreLabel.text = genre.description
  }
}

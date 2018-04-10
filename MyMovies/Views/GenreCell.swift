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
    let imageString = genre.description.lowercased().removeWhitespace()
    imageView.image = UIImage(named: imageString)
    self.layer.cornerRadius = 8.0
    self.layer.borderWidth = 2.0
    self.layer.borderColor = Color.lead.cgColor
  }
}

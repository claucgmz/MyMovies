//
//  SelectableMovieListCell.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class SelectableMovieListCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  
  func configure(with movieList: MovieList, isSelected: Bool) {
    nameLabel.text = movieList.name
    setCurrent(isSelected)
  }
  
  func setCurrent(_ set: Bool) {
    if set {
      accessoryType = .checkmark
    } else {
      accessoryType = .none
    }
  }
}

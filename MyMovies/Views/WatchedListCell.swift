//
//  WatchedListCell.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 4/11/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class WatchedListCell: UITableViewCell {
  @IBOutlet private weak var listNameLabel: UILabel!
  
  func configure(with movieList: MovieList) {
    listNameLabel.text = movieList.name
  }
}

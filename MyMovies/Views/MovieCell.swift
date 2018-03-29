//
//  MovieCell.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import SwipeCellKit
import Cosmos

class MovieCell: SwipeTableViewCell {
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var posterImage: UIImageView!
  @IBOutlet private weak var cosmosView: CosmosView!
  
  func configure(with movie: MovieBrief, delegate: SwipeTableViewCellDelegate) {
    titleLabel.text = movie.title
    if let url = URL(string: APIManager.baseImageURLthumbnail+movie.posterPath) {
      posterImage.af_setImage(withURL: url)
    }
    cosmosView.rating = Double(movie.rating)
    cosmosViewActions()
    self.delegate = delegate
  }
  
  private func cosmosViewActions() {
    cosmosView.didFinishTouchingCosmos = { rating in
      print(rating)
      //DBHandler.setRating(for: self.movie.idString, rating: Int(rating))
    }
  }
  
  override public func prepareForReuse() {
    cosmosView.prepareForReuse()
  }
}

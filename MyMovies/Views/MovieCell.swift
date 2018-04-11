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
  @IBOutlet private weak var watchImageView: UIImageView!
  
  func configure(with movie: MovieBrief, delegate: SwipeTableViewCellDelegate) {
    titleLabel.text = movie.title
    if let url = URL(string: APIManager.baseImageURLthumbnail+movie.posterPath) {
      posterImage.af_setImage(withURL: url)
    }
    
    if movie.watched {
      watchImageView.isHidden = false
      watchImageView.image = watchImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
      watchImageView.tintColor = Color.green
    }
    
    update(Double(movie.rating))
    cosmosViewActions(for: movie.id)
    self.delegate = delegate
  }
  
  func update(_ rating: Double) {
    cosmosView.rating = rating
  }
  
  private func cosmosViewActions(for movieId: String) {
    cosmosView.didFinishTouchingCosmos = { rating in
      DBHandler.setRating(for: movieId, rating: Int(rating))
    }
  }
  
  override public func prepareForReuse() {
    cosmosView.prepareForReuse()
    watchImageView.isHidden = true
  }
}

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
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    func configure(with movie: Movie) {
        setupViews()
        if let url = URL(string: APIManager.baseImageURLthumbnail+movie.posterPath) {
            imageView.af_setImage(withURL: url)
        }
    }
  
    func setupViews() {
        addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
     }
}

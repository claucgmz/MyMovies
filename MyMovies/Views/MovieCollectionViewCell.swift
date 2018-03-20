//
//  MovieCollectionViewCell.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UITableViewCell {
  @IBOutlet private weak var collectionView: UICollectionView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ controller: D, forRow row: Int) {
    collectionView.dataSource = controller
    collectionView.delegate = controller
    collectionView.tag = row
  }
  
  func configure(with view: MovieCollectionView) {
    
  }
}

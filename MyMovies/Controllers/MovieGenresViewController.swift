//
//  MovieGenresViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 4/9/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class MovieGenresViewController: UIViewController {
  @IBOutlet private weak var collectionView: UICollectionView!
  private var genres = [Genre]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    genres = Genre.allElements
  }

}

extension MovieGenresViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return genres.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.reusableId, for: indexPath) as? GenreCell)!
    let genre = genres[indexPath.row]
    cell.configure(genre: genre)
    
    return cell
  }
}

extension MovieGenresViewController: UICollectionViewDelegate {
  
}

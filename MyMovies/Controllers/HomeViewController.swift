//
//  HomeViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import PromiseKit

class HomeViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  private var movieCollectionViews = [MovieCollectionView]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerNib()
    getMovies()
  }
    
    private func registerNib() {
        let headerNib = UINib(nibName: HeaderCollectionReusableView.reusableId, bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.reusableId)
    }
    
  private func getMovies() {
    self.toogleHUD(show: true)
    Handler.getMovies(for: .featured, page: 1)
      .then ({ movies -> Promise<[Movie]> in
        self.movieCollectionViews.append(MovieCollectionView(type: .featured, movies: movies))
        return Handler.getMovies(for: .upcoming, page: 1)
      })
      .map ({ movies in
        self.movieCollectionViews.append(MovieCollectionView(type: .upcoming, movies: movies))
      })
      .done {
        self.collectionView.reloadData()
        self.toogleHUD(show: false)
      }
      .catch({ error -> Void in
        print(error)
      })
  }
  
    // MARK: - Navigation with segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifierString = segue.identifier, let identifier = SegueIdentifier(rawValue: identifierString) else {
      return
    }
    if identifier == .movieDetail {
      guard let controller = segue.destination as? MovieDetailViewController else {
        return
      }
      if sender is Movie {
        guard let movie = sender as? Movie else {
          return
        }
        //May we need to change this for just configure(movie) the complete movie
        // because in this way we need a second request
        controller.movieId = movie.id
        controller.genres = movie.genres
      }
    }
  }
}

// MARK: - Private
private extension HomeViewController {
    func movieForIndexPath(indexPath: IndexPath) -> Movie {
        return movieCollectionViews[(indexPath as NSIndexPath).section].movies[(indexPath as IndexPath).row]
    }
}

// MARK: - CollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    //heightforrow 470
    //heightforheader 30
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return movieCollectionViews.count
  }
    
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movieCollectionViews[section].movies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.reusableId, for: indexPath) as? MovieCollectionCell)!
    let movie = movieForIndexPath(indexPath: indexPath)
    cell.configure(with: movie)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
        let headerView = (collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.reusableId, for: indexPath) as? HeaderCollectionReusableView)!
        headerView.titleLabel.text = movieCollectionViews[(indexPath as NSIndexPath).section].type.rawValue
        return headerView
    default:
        assert(false, "Unexpected element kind")
    }
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 1000, height: 40)
    }
}
// MARK: - CollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movie = movieCollectionViews[collectionView.tag].movies[indexPath.row]
    performSegue(withIdentifier: SegueIdentifier.movieDetail.rawValue, sender: movie)
  }
}

//
//  HomeViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import PromiseKit

class HomeViewController: UICollectionViewController {
  fileprivate let cellId = "cellId"
  private var movieCollectionViews = [MovieCollectionView]()
    var movieCategories = [MovieCategory]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Movies"
    collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
    getMovies()
  }
    
  private func getMovies() {
    self.toogleHUD(show: true)
    Handler.getMovies(for: .featured, page: 1)
      .then ({ movies -> Promise<[Movie]> in
        let featuredCategory = MovieCategory()
        featuredCategory.name = "The best featured movies"
        featuredCategory.movies = movies
        self.movieCategories.append(featuredCategory)
        self.movieCollectionViews.append(MovieCollectionView(type: .featured, movies: movies))
        return Handler.getMovies(for: .upcoming, page: 1)
      })
      .map ({ movies in
        let upcomingCategory = MovieCategory()
        upcomingCategory.name = "The best upcoming movies"
        upcomingCategory.movies = movies
        self.movieCategories.append(upcomingCategory)
        self.movieCollectionViews.append(MovieCollectionView(type: .upcoming, movies: movies))
      })
      .done {
        self.collectionView?.reloadData()
        self.toogleHUD(show: false)
      }
      .catch({ error -> Void in
        print(error)
      })
  }
    
    func showMovieDetailForMovie(_ movie: Movie) {
        performSegue(withIdentifier: SegueIdentifier.movieDetail.rawValue, sender: movie)
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

    func movieForIndexPath(indexPath: IndexPath) -> Movie {
        return movieCollectionViews[(indexPath as NSIndexPath).section].movies[(indexPath as IndexPath).row]
    }

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
    
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if !movieCategories.isEmpty {
        print("regresa count \(movieCategories.count)")
        return movieCategories.count
    }
    return 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell)
    cell.movieCategory = movieCategories[indexPath.item]
    cell.featuredAppsController = self
    return cell
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
}

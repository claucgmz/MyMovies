//
//  HomeViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import PromiseKit
import NotificationBannerSwift

class HomeViewController: UICollectionViewController {
  fileprivate let cellId = "cellId"
  private var movieCollectionViews = [MovieCollectionView]()
  var movieCategories = [MovieCategory]()
  var currentpage = 1
  var totalPages = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "My Movies"
    collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
    getMovies()
  }
    
  func getMovies() {
    self.toogleHUD(show: true)
    Handler.getMovies(for: .featured, page: currentpage)
      .then ({ response -> Promise<PaginatedResponse> in
        self.findOrCreateCategory(type: .featured, movies: response.results)
        return Handler.getMovies(for: .upcoming, page: self.currentpage)
      })
      .map ({ response in
        self.totalPages = response.totalPages
        self.currentpage = response.currentPage
        self.findOrCreateCategory(type: .upcoming, movies: response.results)
      })
      .done {
        self.collectionView?.reloadData()
        self.toogleHUD(show: false)
      }
      .catch({ error -> Void in
        if error._code == NSURLErrorTimedOut {
            let banner = NotificationBanner(title: "Network", subtitle: "You have troubles with your conectivity", style: .danger)
            banner.show()
        }
      })
  }
    
    private func findOrCreateCategory(type: MovieType, movies: [Movie]) {
        if let categoryIndex = self.movieCategories.index(where: {$0.type == type.rawValue}) {
            self.movieCategories[categoryIndex].movies?.append(contentsOf: movies)
            self.movieCollectionViews[categoryIndex].movies.append(contentsOf: movies)
        } else {
            self.movieCategories.append(MovieCategory(name: type, movies: movies))
            self.movieCollectionViews.append(MovieCollectionView(type: type, movies: movies))
        }
        
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
        return movieCategories.count
    }
    return 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CategoryCell)!
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

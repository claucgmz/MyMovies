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
  private var searchController: UISearchController?
  private var genres = [Genre]()
  private var resultsController: SearchViewController?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureSearchController()
    genres = Genre.allElements
  }
  
  private func configureSearchController() {
    let storyboard = UIStoryboard(name: StoryboardPath.main.rawValue, bundle: nil)
    resultsController = (storyboard.instantiateViewController(withIdentifier: ViewControllerPath.searchViewController.rawValue) as? SearchViewController)!
    resultsController?.delegate = self
    searchController = ({
      let searchController = UISearchController(searchResultsController: resultsController)
      searchController.searchResultsUpdater = resultsController
      searchController.hidesNavigationBarDuringPresentation = false
      searchController.dimsBackgroundDuringPresentation = false
      searchController.searchBar.delegate = self
      //setup the search bar
      searchController.searchBar.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
      searchController.searchBar.placeholder = "Search by movie title..."
      searchController.searchBar.sizeToFit()
      navigationItem.titleView = searchController.searchBar
      definesPresentationContext = true
      return searchController
    })()
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifierString = segue.identifier, let identifier = SegueIdentifier(rawValue: identifierString) else {
      return
    }
    
    if identifier == .genreMovieSearch {
      guard let controller = segue.destination as? SearchViewController else {
        return
      }
      
      if sender is Genre {
        guard let genre = sender as? Genre else {
          return
        }
        
        controller.genre = genre
      }
    } else if identifier == .movieDetailFromSearchDelegate {
      guard let controller = segue.destination as? MovieDetailViewController else {
        return
      }
      
      if sender is Movie {
        guard let movie = sender as? Movie else {
          return
        }
        
        controller.movieId = movie.id
      }
    }
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
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let genre = genres[indexPath.row]
    performSegue(withIdentifier: SegueIdentifier.genreMovieSearch.rawValue, sender: genre)
  }
}

extension MovieGenresViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width * 0.45, height: 150.0)
  }
}

extension MovieGenresViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    guard let searchText = searchBar.text else {
      return
    }
    resultsController?.performSearch(with: searchText)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    resultsController?.cleanSearch()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      resultsController?.cleanSearch()
    }
  }
}

extension MovieGenresViewController: SearchViewControllerDelegate {
  func segueToMovieDetail(for movie: Movie?) {
   performSegue(withIdentifier: SegueIdentifier.movieDetailFromSearchDelegate.rawValue, sender: movie)
  }
}

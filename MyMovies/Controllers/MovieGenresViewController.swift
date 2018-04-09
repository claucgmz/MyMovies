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
  @IBOutlet private weak var searchBarContainer: UIView!
  private var searchController: UISearchController?
  private var genres = [Genre]()
  override func viewDidLoad() {
    super.viewDidLoad()
    configureSearchController()
    genres = Genre.allElements
  }
  
  private func configureSearchController() {
    searchController = ({
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let resultsController = (storyboard.instantiateViewController(withIdentifier: "searchResults") as? SearchViewController)!
      
      let searchController = UISearchController(searchResultsController: resultsController)
      searchController.searchResultsUpdater = self
      searchController.hidesNavigationBarDuringPresentation = true
      searchController.dimsBackgroundDuringPresentation = false
      searchController.searchBar.delegate = self
      //setup the search bar
      searchController.searchBar.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
      self.searchBarContainer?.addSubview(searchController.searchBar)
      searchController.searchBar.sizeToFit()
      
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
    }
  }
}

extension MovieGenresViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    
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
    return CGSize(width: collectionView.frame.width * 0.45, height: collectionView.frame.width * 0.45)
  }
}

extension MovieGenresViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    print("hellooo")
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      
    }
  }
}

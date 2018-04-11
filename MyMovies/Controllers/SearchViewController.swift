//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Haydee Rodriguez on 4/2/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import PromiseKit
import DZNEmptyDataSet

protocol SearchViewControllerDelegate: class {
  func segueToMovieDetail(for movie: Movie?)
}

class SearchViewController: UIViewController {
  @IBOutlet weak private var tableView: UITableView!
  private var results = [Movie]()
  private var currentpage = 1
  private var totalPages = 1
  var genre: Genre?
  var searchText: String?
  weak var delegate: SearchViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.emptyDataSetSource = self
    tableView.emptyDataSetDelegate = self
    self.tableView.tableFooterView = UIView()
    performGenreSearch()
  }
  
  func performSearch(with text: String) {
    searchText = text
    performSearch(clear: true)
  }
  
  private func performGenreSearch() {
    guard let genre = genre else {
      return
    }
    
    title = genre.description
    let genreId = genre.rawValue
    self.toogleHUD(show: true)
    Handler.getMoviesByGenre(by: genreId, page: currentpage)
      .map ({ response in
        self.totalPages = response.totalPages
        self.currentpage = response.currentPage
        self.results.append(contentsOf: response.results)
      })
      .done {
        self.tableView.reloadData()
        self.toogleHUD(show: false)
      }
      .catch({ error -> Void in
        self.toogleHUD(show: false)
        ErrorHandler.handle(spellError: ErrorType.connectivity)
      })
  }
  
  private func performSearch(clear: Bool) {
    guard let searchText = searchText else {
      return
    }
    
    if clear == true {
      cleanSearch()
    }
    
    if !searchText.isEmpty {
      self.toogleHUD(show: true)
      Handler.searchMovies(by: searchText, page: currentpage)
        .map ({ response in
          self.totalPages = response.totalPages
          self.currentpage = response.currentPage
          self.results.append(contentsOf: response.results)
        })
        .done {
          self.tableView.reloadData()
          self.toogleHUD(show: false)
        }
        .catch({ error -> Void in
        self.toogleHUD(show: false)
        ErrorHandler.handle(spellError: ErrorType.connectivity)
        })
    }
  }
  
  func cleanSearch() {
    results = []
    currentpage = 1
    totalPages = 1
    tableView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifierString = segue.identifier, let identifier = SegueIdentifier(rawValue: identifierString) else {
      return
    }
    
    if identifier == .movieDetailFromSearch {
      guard let controller = segue.destination as? MovieDetailViewController else {
        return
      }
      if sender is Movie {
        guard let movie = sender as? Movie else {
          return
        }
        controller.movieId = movie.id
        controller.genres = movie.genres
      }
    }
  }
}

// MARK: TableView DataSource
extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reusableId, for: indexPath) as? SearchResultCell)!
    let result = results[indexPath.row]
    cell.configure(with: result)
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastCell = results.count - 1
    if lastCell == indexPath.row {
      let nextPage = currentpage + 1
      if nextPage <= totalPages {
        currentpage = nextPage
        performSearch(clear: false)
      }
    }
  }
}
// MARK: TableView Delegate
extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let result = results[indexPath.row]
    if genre != nil {
      performSegue(withIdentifier: SegueIdentifier.movieDetailFromSearch.rawValue, sender: result)
    } else {
      delegate?.segueToMovieDetail(for: result)
    }
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    performSearch(clear: true)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      cleanSearch()
    }
  }
}

extension SearchViewController: DZNEmptyDataSetSource {
  func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
    return UIImage(named: "search")
  }
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "No results to show")
  }
}

extension SearchViewController: DZNEmptyDataSetDelegate {
  func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
    return true
  }
}

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    
  }
}

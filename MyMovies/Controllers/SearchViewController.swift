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

class SearchViewController: UIViewController {
  @IBOutlet weak private var tableView: UITableView!
  @IBOutlet weak private var searchBar: UISearchBar!
  private var results = [SearchResult]()
  private var currentpage = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.becomeFirstResponder()
    tableView.emptyDataSetSource = self
    tableView.emptyDataSetDelegate = self
    searchBar.placeholder = "Search movies..."
    self.tableView.tableFooterView = UIView()
  }
  
  private func performSearch() {
    guard let searchText = searchBar.text else {
      return
    }
    
    cleanSearch()
    
    if !searchText.isEmpty {
      self.toogleHUD(show: true)
      Handler.searchMovies(by: searchText, page: 1)
        .map ({ movies in
          self.results = movies
        })
        .done {
          self.tableView.reloadData()
          self.toogleHUD(show: false)
        }
        .catch({ error -> Void in
          print(error)
        })
    }
  }
  
  private func cleanSearch() {
    results = []
    currentpage = 1
    tableView.reloadData()
  }
  
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
}
// MARK: TableView Delegate
extension SearchViewController: UITableViewDelegate {
  
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    performSearch()
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

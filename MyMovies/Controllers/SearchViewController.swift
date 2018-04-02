//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Haydee Rodriguez on 4/2/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import PromiseKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var movieCollectionViews = [MovieCollectionView]()
    let searchController = UISearchController(searchResultsController: nil)
    var movies = [Movie]()
    var filteredMovies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
        setupSearchController()
        setupScopeBar()
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movie"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setupScopeBar() {
        searchController.searchBar.scopeButtonTitles = ["All", "Category", "Movie", "Actor"]
        searchController.searchBar.delegate = self
    }
    
    private func getMovies() {
        Handler.getMovies(for: .featured, page: 1)
            .then ({ movies -> Promise<[Movie]> in
                self.movies = movies
                return Handler.getMovies(for: .upcoming, page: 1)
            })
            .map ({ movies in
                self.movies = movies
            })
            .done {
                self.tableView.reloadData()
            }
            .catch({ error -> Void in
                print(error)
            })
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
// MARK: DataSource
extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredMovies.count
        }
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let movie: Movie
        if isFiltering() {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        cell.textLabel!.text = movie.title
        cell.detailTextLabel!.text = movie.tagline
        return cell
    }
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredMovies = movies.filter({(movie: Movie) -> Bool in
            let doesCategoryMatch = ( scope == "All" ) || ( movie.title == scope )
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && movie.title.lowercased().contains(searchText.lowercased())
            }
        })
         tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }

}
    // MARK: TableView Delegate
extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

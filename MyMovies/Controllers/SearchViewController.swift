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
import ReachabilitySwift

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var movieCollectionViews = [MovieCollectionView]()
    let searchController = UISearchController(searchResultsController: nil)
    var movies = [Movie]()
    var filteredMovies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        getMovies()
        setupSearchController()
        setupScopeBar()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movie"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setupScopeBar() {
        searchController.searchBar.scopeButtonTitles = [Genre.all.description, Genre.action.description, Genre.adventure.description, Genre.comedy.description]
        searchController.searchBar.delegate = self
    }
    
    private func getMovies() {
        self.toogleHUD(show: true)
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
                self.toogleHUD(show: false)
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
    
    func filterContentForSearchText(_ searchText: String, scope: String = Genre.all.description) {
        filteredMovies = movies.filter({(movie: Movie) -> Bool in
            let genres = movie.genresString.components(separatedBy: " | ")
            let doesCategoryMatch = ( scope == Genre.all.description ) || ( genres.contains(scope))
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        ReachabilityManager.shared.addListener(listener: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ReachabilityManager.shared.removeListener(listener: self)
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
    // MARK: - DZNEmptyDataSetSource Protocol
extension SearchViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "list")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Sorry, We couldn't find any review.")
    }
}

extension SearchViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
    // MARK: - NetworkError Protocol
extension SearchViewController: NetworkStatusListener {
    
    func networkStatusDidChange(status: Reachability.NetworkStatus) {
    
        switch status {
        case .notReachable:
            debugPrint("ViewController: Network became unreachable")
        case .reachableViaWiFi:
            debugPrint("ViewController: Network reachable through WiFi")
        case .reachableViaWWAN:
            debugPrint("ViewController: Network reachable through Cellular Data")
        }
        
    }
}

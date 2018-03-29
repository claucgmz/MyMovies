//
//  MovieListsViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/22/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class MovieListsViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  private var movieLists = [MovieList]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 80
    MyMoviesService.getUserMovieLists()
      .then(execute: { moviesLists -> Void in
        print(moviesLists)
        self.movieLists = moviesLists
        self.tableView.reloadData()
      }).catch(execute: { error in
        print(error)
      })
  }
}

extension MovieListsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieLists.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (tableView.dequeueReusableCell(withIdentifier: MovieListCell.reusableId, for: indexPath) as? MovieListCell)!
    let movieList = movieLists[indexPath.row]
    cell.configure(with: movieList)
    return cell
  }
}

extension MovieListsViewController: UITableViewDelegate {
  
}

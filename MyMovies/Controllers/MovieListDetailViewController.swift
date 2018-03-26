//
//  MovieListDetailViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import SwipeCellKit

class MovieListDetailViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  var movieList: MovieList?
  private var movies = [MovieBrief]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let movieList = movieList else {
      return
    }
    movies = movieList.movies
    tableView.reloadData()
  }
}

extension MovieListDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (tableView.dequeueReusableCell(withIdentifier: MovieCell.reusableId, for: indexPath) as? MovieCell)!
    let movie = movies[indexPath.row]
    cell.configure(with: movie, delegate: self)
    return cell
  }
}

extension MovieListDetailViewController: UITableViewDelegate {
  
}

extension MovieListDetailViewController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { _, indexPath in
      self.movies.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    return [deleteAction]
  }
}

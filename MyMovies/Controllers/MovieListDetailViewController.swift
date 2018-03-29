//
//  MovieListDetailViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import SwipeCellKit
import PromiseKit
import Cosmos

class MovieListDetailViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var cosmosView: CosmosView!
  
  var movieList: MovieList?
  private var movies = [MovieBrief]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let movieList = movieList else {
      return
    }
    
    Handler.getMovies(forList: movieList.id)
    .map({ briefs -> Void in
      self.movies = briefs
    })
      .done {
        self.tableView.reloadData()
    }
    .catch({ error in
      print (error)
    })
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifierString = segue.identifier, let identifier = SegueIdentifier(rawValue: identifierString) else {
      return
    }
    
    if identifier == .movieDetailFromList {
      guard let controller = segue.destination as? MovieDetailViewController else {
        return
      }
      if sender is MovieBrief {
        guard let movie = sender as? MovieBrief else {
          return
        }
        controller.movieId = Int(movie.id)
      }
    }
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
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let movie = movies[indexPath.row]
    performSegue(withIdentifier: SegueIdentifier.movieDetailFromList.rawValue, sender: movie)
  }
}

extension MovieListDetailViewController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { _, indexPath in
      guard let list = self.movieList else {
        return
      }
      
      let movieId = self.movies[indexPath.row].id
      self.movies.remove(at: indexPath.row)
      DBHandler.removeMovie(withId: movieId, from: list.id)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    return [deleteAction]
  }
}

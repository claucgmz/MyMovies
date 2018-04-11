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
import DZNEmptyDataSet

class MovieListDetailViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var cosmosView: CosmosView!
  var movieList: MovieList!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.emptyDataSetSource = self
    tableView.emptyDataSetDelegate = self
    registerNibs()
    getMovieListData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let tableView = tableView else { return }
    getMovieListData()
    tableView.reloadData()
  }
  
  private func registerNibs() {
    tableView.register(UINib(nibName: ProgressHeaderCell.reusableId, bundle: nil), forHeaderFooterViewReuseIdentifier: ProgressHeaderCell.reusableId)
  }
  
  private func getMovieListData() {
    guard let movieList = movieList else {
      return
    }
    
    self.toogleHUD(show: true)
    Handler.getMovies(forList: movieList.id)
      .map({ briefs -> Void in
        self.movieList.movies = briefs
      })
      .done {
        self.tableView.reloadData()
        self.toogleHUD(show: false)
      }
      .catch({ error in
        ErrorHandler.handle(spellError: ErrorType.connectivity)
      })
  }
  
  private func updateProgressView() {
    guard let tableView = tableView else { return }
    tableView.reloadSections(IndexSet(integer: 0), with: .none)
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
    return movieList.movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (tableView.dequeueReusableCell(withIdentifier: MovieCell.reusableId, for: indexPath) as? MovieCell)!
    let movie = movieList.movies[indexPath.row]
    cell.configure(with: movie, delegate: self)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 120
  }
}

extension MovieListDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let movie = movieList.movies[indexPath.row]
    performSegue(withIdentifier: SegueIdentifier.movieDetailFromList.rawValue, sender: movie)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProgressHeaderCell.reusableId) as? ProgressHeaderCell
    guard let movieList = movieList else {
      return nil
    }
    header?.configure(with: movieList)
    return header
  }
}

extension MovieListDetailViewController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { _, indexPath in
      guard let list = self.movieList else {
        return
      }
      
      let movieId = self.movieList.movies[indexPath.row].id
      self.movieList.movies.remove(at: indexPath.row)
      DBHandler.removeMovie(withId: movieId, from: list.id)
      tableView.deleteRows(at: [indexPath], with: .fade)
      self.updateProgressView()
      
      if tableView.numberOfRows(inSection: 0) == 0 {
        tableView.reloadData()
      }
    }
    
    return [deleteAction]
  }
}

extension MovieListDetailViewController: DZNEmptyDataSetSource {
  func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
    return UIImage(named: "movie-b")
  }
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "You don't have any movies in this list.")
  }
}

extension MovieListDetailViewController: DZNEmptyDataSetDelegate {
  func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
    return true
  }
}

//
//  MovieListViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import SwipeCellKit
import DZNEmptyDataSet

class MovieListViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  private var movieLists = [MovieList]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.emptyDataSetSource = self
    tableView.emptyDataSetDelegate = self
    getLists()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if let index = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: index, animated: true)
    }
  }
  
  private func getLists() {
    self.toogleHUD(show: true)
    Handler.getLists().map({ movieLists -> Void in
      self.movieLists = movieLists
      self.movieLists.insert(MovieList.getWatchedList(), at: 0)
    })
      .done {
        self.tableView.reloadData()
        self.toogleHUD(show: false)
    }
    .catch({ error in
        self.toogleHUD(show: false)
        ErrorHandler.handle(spellError: ErrorType.connectivity)
    })
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifierString = segue.identifier, let identifier = SegueIdentifier(rawValue: identifierString) else {
      return
    }
    
    if identifier == .movieListForm {
      guard let controller = segue.destination as? MovieFormViewController else {
        return
      }
      controller.delegate = self
      if sender is MovieList {
        guard let movieList = sender as? MovieList else {
          return
        }
        
        controller.movieList = movieList
      }
    } else if identifier == .movieListDetail {
      guard let controller = segue.destination as? MovieListDetailViewController else {
        return
      }
      if sender is MovieList {
        guard let movieList = sender as? MovieList else {
          return
        }
        controller.movieList = movieList
      }
    }
  }
}

extension MovieListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieLists.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let list = movieLists[indexPath.row]
    
    switch list.id {
    case MovieList.watchedListId:
      let cell = (tableView.dequeueReusableCell(withIdentifier: WatchedListCell.reusableId, for: indexPath) as? WatchedListCell)!
      cell.configure(with: list)
      return cell
    default:
      let cell = (tableView.dequeueReusableCell(withIdentifier: MovieListCell.reusableId, for: indexPath) as? MovieListCell)!
      cell.configure(with: list, delegate: self)
      return cell
    }
  }
}

extension MovieListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let movieList = movieLists[indexPath.row]
    performSegue(withIdentifier: SegueIdentifier.movieListDetail.rawValue, sender: movieList)
    
  }
}

extension MovieListViewController: MovieFormViewControllerDelegate {
  func movieFormViewController(_ controller: MovieFormViewController) {
    getLists()
  }
}

extension MovieListViewController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { _, indexPath in
      DBHandler.removeList(self.movieLists[indexPath.row])
      self.movieLists.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      
      if tableView.numberOfRows(inSection: 0) == 0 {
        tableView.reloadData()
      }
    }
    
    let editAction = SwipeAction(style: .default, title: "Edit") { _, indexPath in
      let movieList = self.movieLists[indexPath.row]
      self.performSegue(withIdentifier: SegueIdentifier.movieListForm.rawValue, sender: movieList)
    }
    editAction.hidesWhenSelected = true
    
    return [deleteAction, editAction]
  }
}

extension MovieListViewController: DZNEmptyDataSetSource {
  func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
    return UIImage(named: "list")
  }
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "You don't have any lists.")
  }
}

extension MovieListViewController: DZNEmptyDataSetDelegate {
  func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
    return true
  }
}

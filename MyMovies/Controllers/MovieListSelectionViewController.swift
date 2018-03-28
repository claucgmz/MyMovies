//
//  MovieListSelectionViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

protocol MovieListSelectionViewControllerDelegate: class {
  func movieListSelectionViewControllerDidFinishSaving(_ controller: UIViewController)
}

class MovieListSelectionViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  private var movieLists = [MovieList]()
  private var movieListId: String?
  private var addedLists = [String]()
  weak var delegate: MovieListSelectionViewControllerDelegate?
  var movieId: String?
  var movieSave: MovieSave?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getMovies()
  }
  
  private func getMovies() {
    guard let movieId = movieId else {
      return
    }
    
    Handler.getLists().then(execute: { lists in
      self.movieLists = lists
      return Handler.getMovieLists(for: movieId)
    }).then(execute: { lists in
      self.addedLists = lists
    })
    .always {
      self.tableView.reloadData()
    }
  }

  @IBAction private func cancelButtonAction(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction private func saveButtonAction(_ sender: Any) {
    guard let movieId = movieId else {
      return
    }
    DBHandler.saveMovieList(for: movieId, lists: addedLists)
    navigationController?.popViewController(animated: true)
    delegate?.movieListSelectionViewControllerDidFinishSaving(self)
  }
}

extension MovieListSelectionViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieLists.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (tableView.dequeueReusableCell(withIdentifier: SelectableMovieListCell.reusableId, for: indexPath) as? SelectableMovieListCell)!
    let movieList = movieLists[indexPath.row]
    cell.configure(with: movieList, isSelected: addedLists.contains(movieList.id))
    return cell
  }
}

extension MovieListSelectionViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let movieId = movieLists[indexPath.row].id
    if let index = addedLists.index(of: movieId) {
      addedLists.remove(at: index)
    } else {
      addedLists.append(movieId)
    }
    tableView.reloadRows(at: [indexPath], with: .fade)
  }
}

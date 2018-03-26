//
//  MovieListViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  private var movieLists = [MovieList]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getMovies()
  }
  
  private func getMovies() {
    Handler.getLists().then(execute: { movieLists -> Void in
      self.movieLists = movieLists
      self.tableView.reloadData()
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
    }
  }
}

extension MovieListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieLists.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (tableView.dequeueReusableCell(withIdentifier: MovieListCell.reusableId, for: indexPath) as? MovieListCell)!
    let list = movieLists[indexPath.row]
    cell.configure(with: list)
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      DBHandler.removeList(movieLists[indexPath.row])
      movieLists.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
}

extension MovieListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let movieList = movieLists[indexPath.row]
    performSegue(withIdentifier: SegueIdentifier.movieListForm.rawValue, sender: movieList)
  }
}

extension MovieListViewController: MovieFormViewControllerDelegate {
  func movieFormViewController(_ controller: MovieFormViewController) {
    getMovies()
  }
}

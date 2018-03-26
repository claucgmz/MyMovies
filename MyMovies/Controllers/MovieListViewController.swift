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
  
}

extension MovieListViewController: MovieFormViewControllerDelegate {
  func movieFormViewController(_ controller: MovieFormViewController) {
    getMovies()
  }
}

//
//  MovieListSelectionViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class MovieListSelectionViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  private var movieLists = [MovieList]()
  var movieListId: String?
  
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
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction private func cancelButtonAction(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction private func saveButtonAction(_ sender: Any) {
    
  }
}

extension MovieListSelectionViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieLists.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (tableView.dequeueReusableCell(withIdentifier: SelectableMovieListCell.reusableId, for: indexPath) as? SelectableMovieListCell)!
    let movieList = movieLists[indexPath.row]
    cell.configure(with: movieList, isSelected: movieList.id == movieListId)
    return cell
  }
}

extension MovieListSelectionViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    movieListId = movieLists[indexPath.row].id
    tableView.reloadData()
  }
}

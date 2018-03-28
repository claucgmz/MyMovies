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
  var movieId: String?
  private var movieListId: String?
  private var movieLists = [MovieList]()
  private var addedLists: [String: Bool] = [:]
  var movieSave: MovieSave?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getMovies()
    getMovieData()
  }
  
  private func getMovies() {
    Handler.getLists().then(execute: { movieLists -> Void in
      self.movieLists = movieLists
      self.tableView.reloadData()
    })
    guard let movieId = movieId else {
      return
    }
    Handler.getMovieData(withId: movieId).then(execute: { movieData -> Void in
      guard let movieData = movieData else {
        return
      }
      self.movieSave = movieData
      self.addedLists = movieData.lists
    }).always {
      self.tableView.reloadData()
    }
  }
  
  private func getMovieData() {
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction private func cancelButtonAction(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction private func saveButtonAction(_ sender: Any) {
    guard let movieId = movieId else {
      return
    }
    DBHandler.saveMovieList(for: movieId, lists: addedLists)
  }
}

extension MovieListSelectionViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieLists.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (tableView.dequeueReusableCell(withIdentifier: SelectableMovieListCell.reusableId, for: indexPath) as? SelectableMovieListCell)!
    let movieList = movieLists[indexPath.row]
    let isSelected = addedLists[movieList.id] != nil
    cell.configure(with: movieList, isSelected: isSelected)
    return cell
  }
}

extension MovieListSelectionViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if addedLists[movieLists[indexPath.row].id] != nil {
      addedLists.removeValue(forKey: movieLists[indexPath.row].id)
    } else {
      addedLists[movieLists[indexPath.row].id] = true
    }
    
    print(addedLists)
    tableView.reloadData()
  }
}

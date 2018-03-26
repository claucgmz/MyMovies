//
//  MovieListViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
  private var movieLists = [MovieList]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Handler.getLists().then(execute: { movies -> Void in
      print(movies)
    })
  }
}

extension MovieListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieLists.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }

}

//
//  HomeViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  private var movieCollectionViews = [MovieCollectionView]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getMovies()
  }
  
  private func getMovies() {
    MyMoviesService.getMovies(for: .featured, page: 1).then(execute: { movies -> Void in
      self.movieCollectionViews.append(MovieCollectionView(type: .featured, movies: movies))
      self.tableView.reloadData()
    }).catch(execute: { error in
      print(error)
    })
    
    MyMoviesService.getMovies(for: .upcoming, page: 1).then(execute: { movies -> Void in
      self.movieCollectionViews.append(MovieCollectionView(type: .upcoming, movies: movies))
      self.tableView.reloadData()
    }).catch(execute: { error in
      print(error)
    })
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifierString = segue.identifier, let identifier = SegueIdentifier(rawValue: identifierString) else {
      return
    }
    switch identifier {
    case .movieDetail:
      guard let controller = segue.destination as? MovieDetailViewController else {
        return
      }
      if sender is Movie {
        guard let movie = sender as? Movie else {
          return
        }
        controller.movieId = movie.id
        controller.genres = movie.genres
      }
    }
  }
}

extension HomeViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return movieCollectionViews.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return movieCollectionViews[section].type.rawValue.uppercased()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (tableView.dequeueReusableCell(withIdentifier: MovieCollectionViewCell.reusableId, for: indexPath) as? MovieCollectionViewCell)!
    cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
    let movieCollectonView = movieCollectionViews[indexPath.section]
    cell.configure(with: movieCollectonView)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 470.0
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.backgroundView?.backgroundColor = Color.lead
    header.textLabel?.textColor = .white
    header.textLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
    header.textLabel?.frame = header.frame
    header.textLabel?.textAlignment = .center
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 55
  }
}

extension HomeViewController: UITableViewDelegate {
  
}

extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movieCollectionViews[collectionView.tag].movies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.reusableId, for: indexPath) as? MovieCollectionCell)!
    let movie = movieCollectionViews[collectionView.tag].movies[indexPath.row]
    cell.configure(with: movie)
    return cell
  }
}

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movie = movieCollectionViews[collectionView.tag].movies[indexPath.row]
    performSegue(withIdentifier: SegueIdentifier.movieDetail.rawValue, sender: movie)
  }
}

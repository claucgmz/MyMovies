//
//  MovieDetailViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/21/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import AlamofireImage
import Cosmos
import PromiseKit
import FacebookShare

class MovieDetailViewController: UIViewController {
  @IBOutlet private weak var movieImageView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var taglineLabel: UILabel!
  @IBOutlet private weak var yearLabel: UILabel!
  @IBOutlet private weak var runtimeLabel: UILabel!
  @IBOutlet private weak var genresLabel: UILabel!
  @IBOutlet private weak var overviewLabel: UILabel!
  @IBOutlet private weak var cosmosView: CosmosView!
  @IBOutlet private weak var movieWatchedButton: UIButton!
  
  private var movie: Movie!
  private var movieWatched = false
  var genres = [Genre]()
  var movieId: Int?
  
  enum MovieWatchedImageName: String {
    case eye
    case eyefilled
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let movieId = movieId else {
      return
    }
    
    let movieStringId = String(movieId)
    self.toogleHUD(show: true)
    Handler.getMovie(withId: movieStringId)
      .then ({ movie -> Promise<Int> in
        self.movie = movie
        self.movie.genres = self.genres
        self.updateUI()
        return Handler.getRating(for: String(movieId))
      })
      .map ({ rating -> Void  in
        self.cosmosView.rating = Double(rating)
      })
      .done {
        self.updateUI()
        self.toogleHUD(show: false)
        self.cosmosViewActions()
      }
      .catch({ error -> Void in
        ErrorHandler.handle(spellError: ErrorType.connectivity)
      })
    
    Handler.isMovieWatched(movieId: movieStringId)
      .map({ watched -> Void in
        self.movieWatched = watched
        self.updateMovieWatchedImage()
      })
      .catch({ error -> Void in
        print(error)
      })
  }
  
  private func cosmosViewActions() {
    cosmosView.didFinishTouchingCosmos = { rating in
      DBHandler.setRating(for: self.movie.idString, rating: Int(rating))
    }
  }
  
  private func updateUI() {
    titleLabel.text = movie.title
    overviewLabel.text = movie.sinopsis + movie.sinopsis + movie.sinopsis
    
    if let url = URL(string: APIManager.baseImageURLdetail+movie.backPath) {
      movieImageView.af_setImage(withURL: url)
    }
    
    genresLabel.text = movie.genresString.uppercased()
    taglineLabel.text = !movie.tagline.isEmpty ? "\"\(movie.tagline)\"" : ""
    runtimeLabel.text = movie.runtime > 0 ? "\(movie.runtime) min." : ""
  }
  
  private func updateRating() {
    cosmosView.rating = 0
  }
  
  private func updateMovieWatchedImage() {
    let buttonImage = UIImage(named: MovieWatchedImageName.eye.rawValue)
    let buttonImageFilled = UIImage(named: MovieWatchedImageName.eyefilled.rawValue)
    var tintedImage = buttonImage?.withRenderingMode(.alwaysTemplate)
    var color = Color.main
    if movieWatched {
      tintedImage = buttonImageFilled?.withRenderingMode(.alwaysTemplate)
      color = Color.green
    }
    movieWatchedButton.setImage(tintedImage, for: .normal)
    movieWatchedButton.tintColor = color
  }
  
  private func saveMovieBrief() {
    let brief = MovieBrief(id: movie.idString, title: movie.title, posterPath: movie.posterPath)
    DBHandler.saveMovieBrief(brief)
  }
  
  @IBAction func setMovieWatched(_ sender: Any) {
    movieWatched = !movieWatched
    DBHandler.setMovieWatched(movieId: movie.idString, watched: movieWatched)
    updateMovieWatchedImage()
    saveMovieBrief()
  }
  
    @IBAction func shareMovie(_ sender: Any) {
        let photo = Photo(image: movieImageView.image!, userGenerated: true)
        let content = PhotoShareContent(photos: [photo])
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            // Handle share results
        }
        do {
            try shareDialog.show()
        } catch {
            ErrorHandler.handle(spellError: ErrorType.notFound)
        }
    }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifierString = segue.identifier, let identifier = SegueIdentifier(rawValue: identifierString) else {
      return
    }
    
    if identifier == .movieListSelection {
      guard let controller = segue.destination as? MovieListSelectionViewController else {
        return
      }
      controller.movieId = movie.idString
      controller.delegate = self
    }
  }
}

extension MovieDetailViewController: MovieListSelectionViewControllerDelegate {
  func movieListSelectionViewControllerDidFinishSaving(_ controller: UIViewController) {
    saveMovieBrief()
  }
}

//
//  ProgressHeaderCell.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 4/11/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class ProgressHeaderCell: UITableViewHeaderFooterView {
  @IBOutlet private weak var movieNameLabel: UILabel!
  @IBOutlet private weak var totalMoviesLabel: UILabel!
  @IBOutlet private weak var progressBar: UIProgressView!
  @IBOutlet private weak var percentageLabel: UILabel!
  
  func configure(with list: MovieList) {
    totalMoviesLabel.text = "\(list.movies.count) movies"
    updateProgressBar(percentage: list.percentage)
  }
  
  private func updateProgressBar(percentage: Double) {
    progressBar.progressTintColor = Color.green
    progressBar.setProgress(Float(percentage), animated: true)
    percentageLabel.text = "\(Int(percentage * 100))%"
  }
}

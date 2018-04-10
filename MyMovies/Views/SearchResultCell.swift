//
//  SearchResultCell.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 4/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
  @IBOutlet private weak var thumbnailView: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var detailLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let selectedView = UIView(frame: CGRect.zero)
    selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
    selectedBackgroundView = selectedView
  }
  func configure(with result: SearchResult) {
    nameLabel.text = !result.title.isEmpty ? result.title : "No title"
    detailLabel.text = result.releaseDate.toString(withFormat: "MMM-dd-YYYY")
    if let url = URL(string: APIManager.baseImageURLthumbnail+result.posterPath) {
      thumbnailView.af_setImage(withURL: url)
    }
  }
  
  override func prepareForReuse() {
    thumbnailView.image = nil
  }
}

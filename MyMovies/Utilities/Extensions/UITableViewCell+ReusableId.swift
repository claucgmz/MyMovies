//
//  UITableViewCell+ReusableId.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

extension UITableViewCell {
  static var reusableId: String {
    return String(describing: self)
  }
}

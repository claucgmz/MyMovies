//
//  UITableViewHeaderFooterView+ReusableId.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 4/11/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

extension UITableViewHeaderFooterView {
  static var reusableId: String {
    return String(describing: self)
  }
}

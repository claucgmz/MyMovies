//
//  UIImageView+TintColor.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 4/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

extension UIImageView {
  func tintImageColor(color: UIColor) {
    self.image = self.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    self.tintColor = color
  }
}

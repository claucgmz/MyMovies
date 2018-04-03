//
//  UIViewController+HUD.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 4/2/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController {
  func toogleHUD(show: Bool) {
    switch show {
    case true:
//      SVProgressHUD.setForegroundColor(.white)
//      SVProgressHUD.setBackgroundLayerColor(.white)
      SVProgressHUD.show()
    case false:
      SVProgressHUD.dismiss()
    }
  }
}

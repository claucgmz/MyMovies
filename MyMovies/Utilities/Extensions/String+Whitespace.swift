//
//  String+Whitespace.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 4/9/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

extension String {
  func removeWhitespace() -> String {
    return self.filter { $0 != Character(" ") }
  }
}

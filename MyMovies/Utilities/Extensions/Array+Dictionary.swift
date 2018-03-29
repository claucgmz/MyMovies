//
//  Array+Dictionary.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/28/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

extension Array {
  public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Element: Key] {
    var dict = [Element: Key]()
    for element in self {
      dict[element] = selectKey(element)
    }
    return dict
  }
}

//
//  DBModel.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/25/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

protocol DBModel {
  var id: String { get set }
  func toDictionary() -> [String: Any]
}

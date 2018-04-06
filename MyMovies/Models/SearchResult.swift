//
//  SearchResult.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 4/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

protocol SearchResult {
  var id: Int { get set }
  var title: String { get set }
  var posterPath: String { get set }
  var releaseDate: Date { get set }
}

//
//  MovieBrief.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

protocol MovieBrief {
  var id: Int! { get set }
  var title: String! { get set }
  var posterPath: String { get set }
}

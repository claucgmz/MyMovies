//
//  MovieFormViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/25/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

protocol MovieFormViewControllerDelegate: class {
  func movieFormViewController(_ controller: MovieFormViewController)
}

class MovieFormViewController: UIViewController {
  private weak var movieFormView: MovieFormView! { return self.view as? MovieFormView }
  private weak var listNameTextField: UITextField! { return movieFormView.listNameTextField }
  private weak var saveButton: UIButton! { return movieFormView.saveButton }
  var movieList: MovieList?
  weak var delegate: MovieFormViewControllerDelegate?
  
  override func loadView() {
    self.view = MovieFormView()
    title = movieList != nil ? "Edit List" : "Add List"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
    
    guard let movieList = movieList else {
      return
    }
    
    self.listNameTextField.text = movieList.name
  }
  
  @objc func saveButtonAction() {
    guard let listName = listNameTextField.text else {
      return
    }
    
    var list = MovieList(name: listName)
    if let movieList = movieList {
      list = movieList
      list.name = listName
    }
    
    DBHandler.saveList(list)
    delegate?.movieFormViewController(self)
    navigationController?.popViewController(animated: true)
  }
}

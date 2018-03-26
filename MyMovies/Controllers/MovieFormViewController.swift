//
//  MovieFormViewController.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/25/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class MovieFormViewController: UIViewController {
  private weak var movieFormView: MovieFormView! { return self.view as? MovieFormView }
  private weak var listNameTextField: UITextField! { return movieFormView.listNameTextField }
  private weak var saveButton: UIButton! { return movieFormView.saveButton }
  
  override func loadView() {
    self.view = MovieFormView()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    self.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
  }
  
  @objc func saveButtonAction() {
    guard let listName = listNameTextField.text else {
      return
    }

    var list = MovieList()
    list.name = listName
    DBHandler.updateList(list)
    navigationController?.popViewController(animated: true)
  }
}

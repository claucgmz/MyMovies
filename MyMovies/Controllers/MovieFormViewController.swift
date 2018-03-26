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
  weak var delegate: MovieFormViewControllerDelegate?
  
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

    let list = MovieList(name: listName)
    DBHandler.updateList(list)
    delegate?.movieFormViewController(self)
    navigationController?.popViewController(animated: true)
  }
}

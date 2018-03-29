//
//  MovieFormView.swift
//  MyMovies
//
//  Created by Caludia Carrillo on 3/25/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class MovieFormView: UIView {
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .black
    self.setSubviewForAutoLayout(self.stackView)
    stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    stackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let listNameTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Movie list name"
    textField.font = UIFont(name: "AvenirNext-Regular", size: 17.0)
    textField.textColor = .gray
    textField.minimumFontSize = 17.0
    textField.borderStyle = .roundedRect
    return textField
  }()
  
  let saveButton: UIButton = {
    let button = UIButton(type: .system)
    button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 17.0)
    button.setTitle("Save", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .clear
    button.layer.borderColor = UIColor.white.cgColor
    button.layer.borderWidth = 1.0
    return button
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [self.listNameTextField, self.saveButton])
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    stackView.spacing = 10.0
    stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    return stackView
  }()
}

//
//  HeaderCollectionReusableView.swift
//  MyMovies
//
//  Created by Haydee Rodriguez on 4/5/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

extension HeaderCollectionReusableView {
    static var reusableId: String {
        return String(describing: self)
    }
}

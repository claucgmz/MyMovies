//
//  LogoutViewController.swift
//  MyMovies
//
//  Created by Haydee Rodriguez on 4/11/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        // Do any additional setup after loading the view.
    }

    @IBAction func logoutAction(_ sender: Any) {
        AuthHandler.logOut(logoutVC: self)
    }
    
    func getUserInfo() {
        AuthHandler.getUserInfo(onSuccess: { userData in
            if let userData = userData {
                if let firstName = userData["first_name"] as? String, let lastName = userData["last_name"] as? String {
                    self.profileName.text = "\(firstName) \(lastName)"
                }
            }
        }, onFailure: { error in
            print(error.localizedDescription)
            ErrorHandler.handle(spellError: ErrorType.connectivity)
        })
    }
    
    func changeView(with storyboardName: String, viewControllerName: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as UIViewController
        present(initialViewController, animated: true, completion: nil)
    }
}

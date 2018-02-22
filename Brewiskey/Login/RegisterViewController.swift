//
//  ViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-21.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var uploadPictureImageView: UIImageView!
    @IBOutlet weak var usernameImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorCircleImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorCircleImageView.isHidden = true
    }
    

    @IBAction func createAccountTapped(_ sender: Any) {
        
        
    }
    
    
    
}



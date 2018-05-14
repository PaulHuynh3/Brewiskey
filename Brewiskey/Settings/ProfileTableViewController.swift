//
//  ProfileTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-24.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class ProfileTableViewController: UITableViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var unitNumberOptionalLabel: UILabel!
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutUserProfile()
    }
    
    fileprivate func setupUI() {
        tableView.backgroundColor = UIColor.brewiskeyColours.lightGray
        view.backgroundColor = UIColor.brewiskeyColours.lightGray
        tableView.isScrollEnabled = false
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    fileprivate func layoutUserProfile(){
        if let firstName = user.firstName {
            firstNameLabel.text = firstName
        }
        if let lastName = user.lastName {
            lastNameLabel.text = lastName
        }
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
            profileImageView.clipsToBounds = true
        }
        
        //Set after the user edits and saves their profile
        if let age = user.age {
            ageLabel.text = age
        }
        if let number = user.address.number {
            numberLabel.text = number
        }
        if let street = user.address.street {
            streetLabel.text = street
        }
        if let city = user.address.city {
            cityLabel.text = city
        }
        if let province = user.address.province {
            provinceLabel.text = province
        }
        if let postalCode = user.address.postalCode {
            postalCodeLabel.text = postalCode
        }
        if let unitNumber = user.address.unitNumber {
            unitNumberOptionalLabel.text = unitNumber
        }
    }
    
    @IBAction func editProfileTapped(_ sender: Any) {
        performSegue(withIdentifier: "editProfileSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            let editProfileTableViewController = segue.destination as! EditProfileTableViewController
            editProfileTableViewController.user = self.user
        }
    }

}

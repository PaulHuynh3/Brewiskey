//
//  SettingsTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-16.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    let customCellIdentifier = "ImageLabelCellIdentifier"
    var user = User()
    var checkoutItems = Array<CheckoutItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserObject()
        fetchCheckoutItems()
        setupUI()
        setupNibTableView()
    }
    
    fileprivate func setupNibTableView() {
        let nibName = "ImageLabelCell"
        let cell = UINib(nibName: nibName, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: customCellIdentifier)
    }
    
    fileprivate func setupUI() {
        tableView.isScrollEnabled = false
        self.tableView.tableFooterView = UIView()
    }
    
    fileprivate func navigateToReferFriend() {
        performSegue(withIdentifier: "referralSegue", sender: nil)
    }
    
    fileprivate func webPortalHelpPage() {
        let link = "http://brewiskey.com/support/"
        guard let url = URL(string: link) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    fileprivate func navigateToMyAccount() {
        performSegue(withIdentifier: "accountSegue", sender: nil)
    }
    
    fileprivate func navigateToPromoCode() {
        performSegue(withIdentifier: "promoCodeSegue", sender: nil)
    }
    fileprivate func navigateToPastOrders() {
        performSegue(withIdentifier: "pastOrdersSegue", sender: nil)
    }
    
    fileprivate func navigateToPayment() {
        performSegue(withIdentifier: "paymentSegue", sender: nil)
    }
    
    fileprivate func fetchUserObject() {
        if let uid = Auth.auth().currentUser?.uid {
            FirebaseAPI.fetchDatabaseCurrentUser(uid: uid) { [weak self] (user) in
              self?.user = user
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "accountSegue" {
            let myAccountTableViewController = segue.destination as! MyAccountTableViewController
            myAccountTableViewController.user = self.user
        }
        
        if segue.identifier == "paymentSegue" {
            let paymentViewController = segue.destination as! PaymentViewController
            paymentViewController.user = self.user
        }
    }
    
    //Mark: Tableview Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        let section = 1
        return section
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageLabelCell =  tableView.dequeueReusableCell(withIdentifier: customCellIdentifier) as! ImageLabelCell
        let myAccount = "My account"
        let referFriend = "Refer a friend"
        let promoCode = "Promo Code"
        let pastOrders = "Past orders"
        let payment = "Payment"
        let help = "Help"
        let logout = "Log out"
        
        if indexPath.row == 0 {
            imageLabelCell.leftImage.image = #imageLiteral(resourceName: "accountIcon")
            imageLabelCell.middleLabel.text = myAccount
            imageLabelCell.accessoryType = .disclosureIndicator
        } else if indexPath.row == 1 {
            imageLabelCell.leftImage.image = #imageLiteral(resourceName: "referFriends")
            imageLabelCell.middleLabel.text = referFriend
            imageLabelCell.accessoryType = .disclosureIndicator
        } else if indexPath.row == 2 {
            imageLabelCell.leftImage.image = #imageLiteral(resourceName: "promoCode")
            imageLabelCell.middleLabel.text = promoCode
            imageLabelCell.accessoryType = .disclosureIndicator
        } else if indexPath.row == 3 {
            imageLabelCell.leftImage.image = #imageLiteral(resourceName: "pastOrders")
            imageLabelCell.middleLabel.text = pastOrders
            imageLabelCell.accessoryType = .disclosureIndicator
        } else if indexPath.row == 4 {
            imageLabelCell.leftImage.image = #imageLiteral(resourceName: "helplogo")
            imageLabelCell.middleLabel.text = help
            imageLabelCell.accessoryType = .none
        } else {
            imageLabelCell.leftImage.image = #imageLiteral(resourceName: "logout")
            imageLabelCell.middleLabel.text = logout
            imageLabelCell.accessoryType = .none
        }
        
        return imageLabelCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0: navigateToMyAccount()
        case 1: navigateToReferFriend()
        case 2: navigateToPromoCode()
        case 3: navigateToPastOrders()
        case 4: webPortalHelpPage()
        case 5: handleLogout()
            
        default: print("default")
        }
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55
    }
}

extension SettingsTableViewController {
    //handle logout
    fileprivate func fetchCheckoutItems() {
        FirebaseAPI().fetchItemsInCart { (checkoutItem: CheckoutItem?, error: String?) in
            if let error = error {
                print(error)
                return
            }
            guard let item = checkoutItem else {return}
            self.checkoutItems.append(item)
        }
    }
   
    private func handleLogout() {
        FirebaseAPI().deleteCheckoutItems(checkoutItems)
        do {
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
            return
        }
        UserDefaultsUtils().deleteAllUserDefaults()
        let fbsdkLogin = FBSDKLoginManager()
        fbsdkLogin.logOut()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.transitionToLogin()
    }
}

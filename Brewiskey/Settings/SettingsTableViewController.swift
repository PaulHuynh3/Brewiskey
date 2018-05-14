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
    let customCellIdentifier = "SimpleOneLabelCellIdentifier"
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserObject()
        setupUI()
        setupNibTableView()
    }
    
    fileprivate func setupNibTableView() {
        let nibName = "SimpleOneLabelCell"
        let cell = UINib(nibName: nibName, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: customCellIdentifier)
    }
    
    fileprivate func setupUI() {
        tableView.backgroundColor = UIColor.brewiskeyColours.lightGray
        view.backgroundColor = UIColor.brewiskeyColours.lightGray
        tableView.isScrollEnabled = false
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
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
    
    //handle logout clear nsuserdefaults, clear any data associated with previous user..
    private func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
            return
        }
        let userDefaultUtils = UserDefaultsUtils()
        userDefaultUtils.clearUserDefaults()
        let fbsdkLogin = FBSDKLoginManager()
        fbsdkLogin.logOut()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.transitionToLogin()
    }
    
    //Mark: Tableview Datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let section = 1
        return section
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = 7
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneLeftLabelCell =  tableView.dequeueReusableCell(withIdentifier: customCellIdentifier) as! SimpleOneLabelCell
        let myAccount = "My account"
        let referFriend = "Refer a friend"
        let promoCode = "Promo Code"
        let pastOrders = "Past orders"
        let payment = "Payment"
        let help = "Help"
        let logout = "Log out"
        
        if indexPath.row == 0 {
            oneLeftLabelCell.leftLabel.text = myAccount
        } else if indexPath.row == 1 {
            oneLeftLabelCell.leftLabel.text = referFriend
        } else if indexPath.row == 2 {
            oneLeftLabelCell.leftLabel.text = promoCode
        } else if indexPath.row == 3 {
            oneLeftLabelCell.leftLabel.text = pastOrders
        } else if indexPath.row == 4 {
            oneLeftLabelCell.leftLabel.text = payment
        } else if indexPath.row == 5 {
            oneLeftLabelCell.leftLabel.text = help
        } else {
            oneLeftLabelCell.leftLabel.text = logout
        }
        oneLeftLabelCell.accessoryType = .disclosureIndicator
        return oneLeftLabelCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0: navigateToMyAccount()
        case 1: navigateToReferFriend()
        case 2: navigateToPromoCode()
        case 3: print("past orders")
        case 4: navigateToPayment()
        case 5: webPortalHelpPage()
        case 6: handleLogout()
            
        default: print("default")
        }
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55
    }

}

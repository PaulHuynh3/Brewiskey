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

    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserObject()
        setupUI()
        setupNibTableView()
    }
    
    fileprivate func setupNibTableView() {
        let cell = UINib(nibName: "OneLeftLabelCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "OneLeftLabelCell")
    }
    
    fileprivate func setupUI() {
        tableView.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
        view.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
        tableView.isScrollEnabled = false
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    fileprivate func navigateToReferFriend() {
        performSegue(withIdentifier: "referralSegue", sender: nil)
    }
    
    fileprivate func webPortalHelpPage() {
        guard let url = URL(string: "http://brewiskey.com/support/") else {
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
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneLeftLabelCell =  tableView.dequeueReusableCell(withIdentifier: "OneLeftLabelCell") as! OneLeftLabelTableViewCell
        let myAccount = "My account"
        let referFriend = "Refer a friend"
        let promoCode = "Promo Code"
        let pastOrders = "Past orders"
        let payment = "Payment"
        let help = "Help"
        let logout = "Log out"
        
        if indexPath.row == 0 {
            oneLeftLabelCell.leftLabel = myAccount
        } else if indexPath.row == 1 {
            oneLeftLabelCell.leftLabel = referFriend
        } else if indexPath.row == 2 {
            oneLeftLabelCell.leftLabel = promoCode
        } else if indexPath.row == 3 {
            oneLeftLabelCell.leftLabel = pastOrders
        } else if indexPath.row == 4 {
            oneLeftLabelCell.leftLabel = payment
        } else if indexPath.row == 5 {
            oneLeftLabelCell.leftLabel = help
        } else {
            oneLeftLabelCell.leftLabel = logout
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

}

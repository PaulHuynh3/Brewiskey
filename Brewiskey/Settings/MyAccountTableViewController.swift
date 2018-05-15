//
//  MyAccountTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-28.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class MyAccountTableViewController: UITableViewController {
    var user = User()
    let customCellIdentifier = "LeftLabelCellIdentifier"
    
    override func viewDidLoad() {
        setupUI()
        setupNibTableView()
    }
    
    fileprivate func setupUI() {
        tableView.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
        view.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
        tableView.isScrollEnabled = false
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    fileprivate func setupNibTableView() {
        let nibName = "LeftLabelCell"
        let cell = UINib(nibName: nibName, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: customCellIdentifier)
    }
    
    fileprivate func showProfile(){
        performSegue(withIdentifier: "profileSegue", sender: nil)
    }
    
    fileprivate func changePassword(){
        performSegue(withIdentifier: "passwordSegue", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            let profileTableViewController = segue.destination as! ProfileTableViewController
            profileTableViewController.user = self.user
        }
    }
    
    //Mark: Tableview Datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = 2
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let simpleOneLabelCell = tableView.dequeueReusableCell(withIdentifier: customCellIdentifier) as! LeftLabelCell
        let profile = "Profile"
        let password = "Password"
        
        if indexPath.row == 0 {
            simpleOneLabelCell.leftLabel.text = profile
        } else {
            simpleOneLabelCell.leftLabel.text = password
        }
        simpleOneLabelCell.accessoryType = .disclosureIndicator
        
        return simpleOneLabelCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0: showProfile()
        case 1: changePassword()
            
        default: print("default")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }


}

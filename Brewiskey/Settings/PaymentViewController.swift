//
//  PaymentViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-05-08.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "ImageLabelCellIdentifier"
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNib()
    }
    
    fileprivate func setupNib() {
        let nibName = "ImageLabelCell"
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    fileprivate func setupUI() {
        tableView.backgroundColor = UIColor.brewiskeyColours.lightGray
        view.backgroundColor = UIColor.brewiskeyColours.lightGray
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    @IBAction func addNewPaymentTapped(_ sender: Any) {
        
    }
}

extension PaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let creditCards = user.creditCards?.count {
            return creditCards
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageLabelCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ImageLabelCell
        
        if let userCreditCards = user.creditCards {
            for creditCard in userCreditCards {
                if creditCard.hasPrefix("4") {
                    return displayVisaCard(indexPath: indexPath)
                } else {
                    return displayMasterCard(indexPath: indexPath)
                }
            }
        }
        return imageLabelCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    fileprivate func displayMasterCard(indexPath: IndexPath) -> UITableViewCell {
        let imageLabelCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ImageLabelCell
        
        return imageLabelCell
    }
    
    fileprivate func displayVisaCard(indexPath: IndexPath) -> UITableViewCell {
        let imageLabelCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ImageLabelCell
        
        return imageLabelCell
    }
    

    
// https://stackoverflow.com/questions/23888682/validate-credit-card-number
// http://www.allappsdevelopers.com/TopicDetail.aspx?TopicID=2f904d05-ff22-457f-814e-0d0287524d64
    
}



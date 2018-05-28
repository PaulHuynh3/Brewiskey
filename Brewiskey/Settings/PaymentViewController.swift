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
        let addNewCard = "addNewCardSegue"
        performSegue(withIdentifier: addNewCard, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

extension PaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageLabelCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ImageLabelCell
        if let cardNumber = user.creditCard.number {
            if cardNumber.hasPrefix("4") {
                return displayVisaCard(indexPath: indexPath)
            } else {
                return displayMasterCard(indexPath: indexPath)
            }
        }
        return imageLabelCell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    fileprivate func displayMasterCard(indexPath: IndexPath) -> UITableViewCell {
        let imageLabelCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ImageLabelCell
        imageLabelCell.leftImage.image = #imageLiteral(resourceName: "mastercard")
        imageLabelCell.middleLabel.text = "mastercard"
        
        return imageLabelCell
    }
    
    fileprivate func displayVisaCard(indexPath: IndexPath) -> UITableViewCell {
        let imageLabelCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ImageLabelCell
        imageLabelCell.leftImage.image = #imageLiteral(resourceName: "visacard")
        imageLabelCell.middleLabel.text = "visacard"
        
        return imageLabelCell
    }
    

    
// https://stackoverflow.com/questions/23888682/validate-credit-card-number
    
}



//
//  PastOrdersTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-05-31.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class PastOrdersTableViewController: UITableViewController {
    
    fileprivate let customCellIdentifier = "PastOrdersCell"
    var orderedDetails = Array<OrderDetails>()
    var emptyView: EmptyCartView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNibTableView(cellIdentifier: customCellIdentifier)
        retrieveOrderedItems()
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func retrieveOrderedItems(){
        FirebaseAPI().fetchOrderedItems { [weak self] (pastOrder: OrderDetails?, error: String?) in
            guard let strongSelf = self else {return}
            if let error = error {
                strongSelf.showAlert(title: UIAlertConstants.titleError, message: error, actionTitle: UIAlertConstants.actionOk)
                return
            }
            guard let pastOrder = pastOrder else {return}
            strongSelf.orderedDetails.append(pastOrder)
            strongSelf.tableView.reloadData()
        }
    }
    
    fileprivate func setupNibTableView(cellIdentifier: String) {
        let nibName = "PastOrdersCell"
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    fileprivate func updateEmptyView() {
        let emptyViewNibName = "EmptyCartView"
        emptyView = EmptyCartView()
        emptyView = Bundle.main.loadNibNamed(emptyViewNibName, owner: nil, options: nil)?.first as? EmptyCartView
        
        emptyView?.titleLabel.text = "Orders Empty"
        emptyView?.descriptionLabel.text = "Make your first purchase \n Using our Marketplace today."
        self.tableView.backgroundView = emptyView
        self.tableView.separatorStyle = .none
    }
}

extension PastOrdersTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orderedDetails.count > 0 {
            tableView.separatorStyle = .singleLine
            emptyView?.isHidden = true
            return orderedDetails.count
        } else {
            updateEmptyView()
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: customCellIdentifier, for: indexPath) as! PastOrdersCell
        cell.setPastOrderCell(orderDetails: orderedDetails[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

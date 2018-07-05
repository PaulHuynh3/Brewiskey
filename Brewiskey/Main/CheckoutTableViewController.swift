//
//  CheckoutTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-06-23.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class CheckoutTableViewController: UITableViewController {
    
    var cartItems = Array <CheckoutItem>()
    let customCellIdentifier = "CheckoutCellIdentifier"
    var emptyView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNibTableViewCell()
        navigationController?.navigationBar.isHidden = true
        fetchCartItems()
        self.tableView.tableFooterView = UIView()
    }
    
    //set delegate to refresh table when items are added into cart..
    fileprivate func fetchCartItems() {
        
        FirebaseAPI().fetchItemsInCart { [weak self] (checkoutItem: CheckoutItem?, error: String?) in
            guard let strongSelf = self else {return}
            if let error = error {
                strongSelf.showAlert(title: UIAlertConstants.titleError, message: error, actionTitle: UIAlertConstants.actionOk)
                return
            }
            guard let item = checkoutItem else {return}
            
            strongSelf.cartItems.append(item)
            strongSelf.tableView.reloadData()
        }

    }
    
    fileprivate func setupNibTableViewCell() {
        let nibName = "CheckoutCell"
        let cell = UINib(nibName: nibName, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: customCellIdentifier)
    }
    
    fileprivate func updateEmptyView() {
        let emptyViewNibName = "EmptyCartView"
        emptyView = UIView()
        emptyView = Bundle.main.loadNibNamed(emptyViewNibName, owner: nil, options: nil)?.first as? EmptyCartView
            self.tableView.backgroundView = emptyView
            self.tableView.separatorStyle = .none
        
    }

    @objc fileprivate func proceedButtonTapped() {
        print("Proceed Button tapped")
        //navigate to final screen with their information
    }
}

extension CheckoutTableViewController {
    // MARK: - Tableview datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cartItems.count > 0 {
            tableView.separatorStyle = .singleLine
            emptyView?.isHidden = true
            return cartItems.count
        } else {
            updateEmptyView()
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let checkoutCell =  tableView.dequeueReusableCell(withIdentifier: customCellIdentifier) as! CheckoutCell
        checkoutCell.accessoryType = .disclosureIndicator
        let item = cartItems[indexPath.row]
        if let quantity = item.quantity {
            checkoutCell.quantityLabel.text = "\(String(quantity))x"
        }
        if let name = item.name, let type = item.type {
            checkoutCell.nameTypeLabel.text = "\(name) - \(type)"
        }
        if let price = item.price, let quantity = item.quantity {
            
            let perItemTotalCost = price * Double(quantity)
            checkoutCell.costLabel.text = "\(String(perItemTotalCost))$"
        }
        return checkoutCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightForRow: CGFloat = 65
        return heightForRow
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let proceedButton = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: footerView.frame.height))
        proceedButton.setTitle("Proceed To Payment", for: .normal)
        proceedButton.setTitleColor(.white, for: .normal)
        proceedButton.backgroundColor = .black
        proceedButton.addTarget(self, action: #selector(proceedButtonTapped), for: .touchUpInside)
        
        footerView.addSubview(proceedButton)
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            cartItems.remove(at: indexPath.row)
             let orderNumber = indexPath.row
            
          //deletion from firebase database works but its incorrect indexpath..
            guard let uid = FirebaseConstants.currentUserID else {return}
           FirebaseConstants.database.child("users").child(uid).child("cart").child("order_\(orderNumber)").removeValue()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension CheckoutTableViewController {
    //paginate the Proceed button
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    
    
}

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
    var emptyView: EmptyCartView?
    var proceedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNibTableViewCell()
        navigationController?.navigationBar.isHidden = true
        fetchCartItems()
        self.tableView.tableFooterView = UIView()
        registerHeaderNib()
    }
    
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
    
    fileprivate func registerHeaderNib() {
        let header = "TableSectionHeader"
        let nib = UINib(nibName: header, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: header)
    }
    
    fileprivate func setupNibTableViewCell() {
        let nibName = "CheckoutCell"
        let cell = UINib(nibName: nibName, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: customCellIdentifier)
    }
    
    fileprivate func updateEmptyView() {
        let emptyViewNibName = "EmptyCartView"
        emptyView = EmptyCartView()
        emptyView = Bundle.main.loadNibNamed(emptyViewNibName, owner: nil, options: nil)?.first as? EmptyCartView
        
        emptyView?.descriptionLabel.text = "Relax.\n We've got you covered\n Add your items and we'll be there."
            self.tableView.backgroundView = emptyView
            self.tableView.separatorStyle = .none
    }

    @objc fileprivate func proceedButtonTapped() {
        print("Proceed Button tapped")
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
            proceedButton?.isHidden = false
            return cartItems.count
        } else {
            updateEmptyView()
            proceedButton?.isHidden = true
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = cartItems[indexPath.row]
        
        let checkoutCell =  tableView.dequeueReusableCell(withIdentifier: customCellIdentifier) as! CheckoutCell
        checkoutCell.accessoryType = .disclosureIndicator
        checkoutCell.item = item
        checkoutCell.setCheckoutCell()

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
        proceedButton = UIButton(frame: CGRect(x: 0, y: 0, width: footerView.frame.width, height: footerView.frame.height))
        if let proceedButton = proceedButton {
        proceedButton.setTitle("Proceed To Payment", for: .normal)
        proceedButton.setTitleColor(.white, for: .normal)
        proceedButton.backgroundColor = .black
        proceedButton.addTarget(self, action: #selector(proceedButtonTapped), for: .touchUpInside)
        footerView.addSubview(proceedButton)
        }
        if cartItems.count == 0 {
            proceedButton?.isHidden = true
        }
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.rowHeight = 65
        // Dequeue with the reuse identifier
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
        let header = cell as! TableSectionHeader
        
        header.deleteCart.isHidden = false
        header.deleteCart.addTarget(self, action: #selector(deleteCartTapped), for: .touchUpInside)
        
        if cartItems.count < 1 {
            header.deleteCart.isHidden = true
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let orderUuid = cartItems[indexPath.row].orderId else {return}
            guard let uid = FirebaseConstants.currentUserID else {return}
            cartItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            FirebaseConstants.database.child("users").child(uid).child("cart").child(orderUuid).removeValue()
        }
        
    }
}

extension CheckoutTableViewController {
    @objc fileprivate func deleteCartTapped() {
        let alertController = UIAlertController(title: "Delete", message: "All cart items will be deleted", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            guard let uid = FirebaseConstants.currentUserID else {return}
            
            for cartItem in self.cartItems {
                if let orderId = cartItem.orderId{
                    FirebaseConstants.database.child("users").child(uid).child("cart").child(orderId).removeValue()
                }
            }
            UserDefaults.standard.set(nil, forKey: kUserInfo.kCheckoutOrderQuantity)
            self.cartItems.removeAll()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

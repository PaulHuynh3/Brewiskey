//
//  CheckoutTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-06-23.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class CheckoutTableViewController: UITableViewController {
    
    var selectedAlcohols: Array<Beer>?
    let customCellIdentifier = "CheckoutCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNibTableViewCell()
        navigationController?.navigationBar.isHidden = true
    }

    fileprivate func setupNibTableViewCell() {
        let nibName = "CheckoutCell"
        let cell = UINib(nibName: nibName, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: customCellIdentifier)
    }
    
    fileprivate func updateEmptyView() {
        let emptyViewNibName = "EmptyCartView"
        if let emptyView = Bundle.main.loadNibNamed(emptyViewNibName, owner: nil, options: nil)?.first as? EmptyCartView {
            self.tableView.backgroundView = emptyView
            self.tableView.separatorStyle = .none
        }
    }


}
extension CheckoutTableViewController {
    // MARK: - Tableview datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let alcoholItems = selectedAlcohols {
            return alcoholItems.count
        } else {
            updateEmptyView()
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let checkoutCell =  tableView.dequeueReusableCell(withIdentifier: customCellIdentifier) as! CheckoutCell
        checkoutCell.accessoryType = .disclosureIndicator
        if let alcoholBeer = selectedAlcohols?[indexPath.row] {
            
            checkoutCell.costLabel.text = alcoholBeer.singleBottlePrice
            checkoutCell.quantityTypeLabel.text = alcoholBeer.name
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
}

//
//  MoreTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-25.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected", indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:print("First")
        case 1:print("second")
        default: print("default")
            
        }
        
    }
    

    


}

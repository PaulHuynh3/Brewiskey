//
//  PaymentViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-05-08.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as! UITableViewCell
        return cell
    }
// https://stackoverflow.com/questions/23888682/validate-credit-card-number
// http://www.allappsdevelopers.com/TopicDetail.aspx?TopicID=2f904d05-ff22-457f-814e-0d0287524d64
    
}

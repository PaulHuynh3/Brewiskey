//
//  EmailSentViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-06.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class EmailSentViewController: UIViewController {
    
    @IBAction func soundsGoodButtonTapped(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
}

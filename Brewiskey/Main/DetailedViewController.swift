//
//  DetailedTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-03-01.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    var beerMode = false
    var wineMode = false
    var spiritMode = false
    
    var beer: Beer?
    var wine: Wine?
    var spirit: Spirit?
    
    @IBOutlet weak var alcoholNameLabel: UILabel!
    
    @IBOutlet weak var selectionOneImageview: UIImageView!
    @IBOutlet weak var selectionTwoImageview: UIImageView!
    @IBOutlet weak var selectionThreeImageview: UIImageView!
    @IBOutlet weak var selectionFourImageview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAndSetUpLabels()
        setupTapGesture()
    }
    
    fileprivate func configureAndSetUpLabels(){
        if beerMode == true{
           configureBeerMode()
        }
        else if wineMode == true {
            alcoholNameLabel.text = wine?.name
        }
        else if spiritMode == true {
    
            alcoholNameLabel.text = spirit?.name
        }
    }
    
    fileprivate func configureBeerMode() {
        alcoholNameLabel.text = beer?.name
        if let selectionOneImage = beer?.singleBottleImageUrl {
            selectionOneImageview.loadImagesUsingCacheWithUrlString(urlString: selectionOneImage)
        }
    }
    
    fileprivate func setupTapGesture() {
        let selectionOneTapped = UITapGestureRecognizer(target: self, action: #selector(selectionOneSelected))
        selectionOneImageview.isUserInteractionEnabled = true
        selectionOneImageview.addGestureRecognizer(selectionOneTapped)
    }
    
    @objc fileprivate func selectionOneSelected() {
        print("selection 1 selected")
        selectionOneImageview.frame = view.frame
        selectionOneImageview.contentMode = .scaleAspectFit
        
    }
}

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
    fileprivate var isFullScreen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAndSetUpName()
        setupTapGesture()
    }
    
    fileprivate func configureAndSetUpName() {
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
        if let selectionTwoImage = beer?.singleCanImageUrl {
            selectionTwoImageview.loadImagesUsingCacheWithUrlString(urlString: selectionTwoImage)
        }
        if let selectionThreeImage = beer?.sixPackBottleImageUrl {
            selectionThreeImageview.loadImagesUsingCacheWithUrlString(urlString: selectionThreeImage)
        }
        if let selectionFourImage = beer?.sixPackCanImageUrl {
            selectionFourImageview.loadImagesUsingCacheWithUrlString(urlString: selectionFourImage)
        }
    }
  
}

extension DetailedViewController {
    
    fileprivate func setupTapGesture() {
        let selectionOneTapped = UITapGestureRecognizer(target: self, action: #selector(selectionOneSelected))
        selectionOneImageview.isUserInteractionEnabled = true
        selectionOneImageview.addGestureRecognizer(selectionOneTapped)
        
        let selectionTwoTapped = UITapGestureRecognizer(target: self, action: #selector(selectionTwoSelected))
        selectionTwoImageview.isUserInteractionEnabled = true
        selectionTwoImageview.addGestureRecognizer(selectionTwoTapped)
        
        let selectionThreeTapped = UITapGestureRecognizer(target: self, action: #selector(selectionThreeSelected))
        selectionThreeImageview.isUserInteractionEnabled = true
        selectionThreeImageview.addGestureRecognizer(selectionThreeTapped)
        
        let selectionFourTapped = UITapGestureRecognizer(target: self, action: #selector(selectionFourSelected))
        selectionFourImageview.isUserInteractionEnabled = true
        selectionFourImageview.addGestureRecognizer(selectionFourTapped)
    }
    
    @objc fileprivate func selectionOneSelected() {
        if !isFullScreen {
            image(selectedImageview: selectionOneImageview)
            selectionTwoImageview.isHidden = true
            selectionThreeImageview.isHidden = true
            selectionFourImageview.isHidden = true
            isFullScreen = true
        } else {
            dismissSelectionOneFullImage()
            isFullScreen = false
        }
    }
    
    @objc fileprivate func selectionTwoSelected() {
        if !isFullScreen {
            image(selectedImageview: selectionTwoImageview)
            selectionOneImageview.isHidden = true
            selectionThreeImageview.isHidden = true
            selectionFourImageview.isHidden = true
            isFullScreen = true
        } else {
            dismissSelectionTwoFullImage()
            isFullScreen = false
        }
    }
    
    @objc fileprivate func selectionThreeSelected() {
        if !isFullScreen {
            image(selectedImageview: selectionThreeImageview)
            selectionOneImageview.isHidden = true
            selectionTwoImageview.isHidden = true
            selectionFourImageview.isHidden = true
            isFullScreen = true
        } else {
            dismissSelectionThreeFullImage()
            isFullScreen = false
        }
    }
    
    @objc fileprivate func selectionFourSelected() {
        if !isFullScreen {
            image(selectedImageview: selectionFourImageview)
            selectionOneImageview.isHidden = true
            selectionTwoImageview.isHidden = true
            selectionThreeImageview.isHidden = true
            isFullScreen = true
        } else {
            dismissSelectionFourFullImage()
            isFullScreen = false
        }
    }
    
    fileprivate func image(selectedImageview: UIImageView) {
        selectedImageview.frame = view.frame
        selectedImageview.contentMode = .scaleAspectFit
        selectedImageview.backgroundColor = .white
    }
    
    fileprivate func dismissSelectionOneFullImage() {
        selectionOneImageview.frame.origin.x = 9
        selectionOneImageview.frame.origin.y = 132
        selectionOneImageview.frame.size.width = 174
        selectionOneImageview.frame.size.height = 153
        selectionTwoImageview.isHidden = false
        selectionThreeImageview.isHidden = false
        selectionFourImageview.isHidden = false
    }
    fileprivate func dismissSelectionTwoFullImage() {
        selectionTwoImageview.frame.origin.x = 191
        selectionTwoImageview.frame.origin.y = 132
        selectionTwoImageview.frame.size.width = 174
        selectionTwoImageview.frame.size.height = 153
        selectionOneImageview.isHidden = false
        selectionThreeImageview.isHidden = false
        selectionFourImageview.isHidden = false
    }
    fileprivate func dismissSelectionThreeFullImage() {
        selectionThreeImageview.frame.origin.x = 9
        selectionThreeImageview.frame.origin.y = 305
        selectionThreeImageview.frame.size.width = 174
        selectionThreeImageview.frame.size.height = 153
        selectionOneImageview.isHidden = false
        selectionTwoImageview.isHidden = false
        selectionFourImageview.isHidden = false
    }
    fileprivate func dismissSelectionFourFullImage() {
        selectionFourImageview.frame.origin.x = 191
        selectionFourImageview.frame.origin.y = 305
        selectionFourImageview.frame.size.width = 174
        selectionFourImageview.frame.size.height = 153
        selectionOneImageview.isHidden = false
        selectionTwoImageview.isHidden = false
        selectionThreeImageview.isHidden = false
    }
}

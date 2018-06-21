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
    fileprivate var headerLabel: UILabel!
    fileprivate var footerLabel: UILabel!
    @IBOutlet weak var alcoholNameLabel: UILabel!
    @IBOutlet weak var selectionOneImageview: UIImageView!
    @IBOutlet weak var selectionTwoImageview: UIImageView!
    @IBOutlet weak var selectionThreeImageview: UIImageView!
    @IBOutlet weak var selectionFourImageview: UIImageView!
    fileprivate var isFullScreen = false
    let lightBlue = UIColor(red: 138.0/255.0, green: 241.0/255.0, blue: 255.0/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAndSetUpName()
        setupTapGesture()
    }
    
    fileprivate func configureAndSetUpName() {
        if beerMode == true {
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
    //specific setup for selections
    fileprivate func setupTypeLabelSelectionOne() {
        if beerMode && isFullScreen {
            if let beerType = beer?.singleBottleType {
                let bottlePriceWidth: CGFloat = 100
                let bottlePriceHeight: CGFloat = 100
                let xPosition = headerLabel.frame.midX
                let yPosition = headerLabel.frame.minY
                let beerTypeLabel = UILabel(frame: CGRect(x: xPosition, y: yPosition, width: bottlePriceWidth, height: bottlePriceHeight))
                beerTypeLabel.center = headerLabel.center
                beerTypeLabel.text = beerType
                headerLabel.addSubview(beerTypeLabel)
            }
        }
    }

}

extension DetailedViewController {
    //setup for all selections
    fileprivate func setupHeaderLabel(_ selectionImageview: UIImageView) {
        if isFullScreen {
            let labelWidth = selectionImageview.frame.width
            let labelHeight: CGFloat = 60
            let xPosition = selectionImageview.frame.minX
            let yPosition = selectionImageview.frame.minY
     
            headerLabel = UILabel(frame: CGRect(x: xPosition, y: yPosition, width: labelWidth, height: labelHeight))
            headerLabel.backgroundColor = .white
            selectionImageview.addSubview(headerLabel)
        }
    }
    
    fileprivate func setupFooterLabel(_ selectionImageview: UIImageView) {
        if isFullScreen {
            let labelWidth = selectionImageview.frame.width
            let labelHeight: CGFloat = 70
            let xPosition = selectionImageview.frame.minX
            let yPosition = selectionImageview.frame.maxY - labelHeight
            footerLabel = UILabel(frame: CGRect(x: xPosition, y: yPosition, width: labelWidth, height: labelHeight))
            footerLabel.backgroundColor = lightBlue
            selectionImageview.addSubview(footerLabel)
        }
    }
    
    fileprivate func setupCheckoutButton(_ selectionImageview: UIImageView) {
        if isFullScreen {
            let checkoutButtonWidth: CGFloat = 100
            let checkoutButtonHeight: CGFloat = 100
            let xPosition = headerLabel.frame.width - checkoutButtonWidth
            let yPosition: CGFloat = 0
            let checkoutButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: checkoutButtonWidth, height: checkoutButtonHeight))
            checkoutButton.imageView?.image = #imageLiteral(resourceName: "partyHard")
            
            headerLabel.addSubview(checkoutButton)
        }
    }
}

extension DetailedViewController {
    
    fileprivate func isFullScreen(hideImageview: UIImageView, hideImageviewOne: UIImageView, hideImageviewTwo: UIImageView) -> Bool {
        if !isFullScreen {
            tabBarController?.tabBar.isHidden = true
            navigationController?.navigationBar.isHidden = true
            isFullScreen = true
            hideImageview.isHidden = true
            hideImageviewOne.isHidden = true
            hideImageviewTwo.isHidden = true
            return isFullScreen
        } else {
            isFullScreen = false
            return isFullScreen
        }
    }
    
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
        if isFullScreen(hideImageview: selectionTwoImageview, hideImageviewOne: selectionThreeImageview, hideImageviewTwo: selectionFourImageview) {
            image(selectedImageview: selectionOneImageview)
            setupFooterLabel(selectionOneImageview)
            setupHeaderLabel(selectionOneImageview)
            setupTypeLabelSelectionOne()
            setupCheckoutButton(selectionOneImageview)
        } else {
            tabBarController?.tabBar.isHidden = false
            navigationController?.navigationBar.isHidden = false
            dismissSelectionOneFullImage()
        }
    }
    
    @objc fileprivate func selectionTwoSelected() {
        if isFullScreen(hideImageview: selectionOneImageview, hideImageviewOne: selectionThreeImageview, hideImageviewTwo: selectionFourImageview) {
            image(selectedImageview: selectionTwoImageview)
            setupFooterLabel(selectionTwoImageview)
            setupHeaderLabel(selectionTwoImageview)
            
        } else {
            tabBarController?.tabBar.isHidden = false
            navigationController?.navigationBar.isHidden = false
            dismissSelectionTwoFullImage()
        }
    }
    
    @objc fileprivate func selectionThreeSelected() {
        if isFullScreen(hideImageview: selectionOneImageview, hideImageviewOne: selectionTwoImageview, hideImageviewTwo: selectionFourImageview) {
            image(selectedImageview: selectionThreeImageview)
            setupFooterLabel(selectionThreeImageview)
            setupHeaderLabel(selectionThreeImageview)
            
        } else {
            tabBarController?.tabBar.isHidden = false
            navigationController?.navigationBar.isHidden = false
            dismissSelectionThreeFullImage()
        }
    }
    
    @objc fileprivate func selectionFourSelected() {
        if isFullScreen(hideImageview: selectionOneImageview, hideImageviewOne: selectionTwoImageview, hideImageviewTwo: selectionThreeImageview) {
            image(selectedImageview: selectionFourImageview)
            setupFooterLabel(selectionFourImageview)
            setupHeaderLabel(selectionFourImageview)
            
        } else {
            tabBarController?.tabBar.isHidden = false
            navigationController?.navigationBar.isHidden = false
            dismissSelectionFourFullImage()
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
        headerLabel.isHidden = true
        footerLabel.isHidden = true
    }
    fileprivate func dismissSelectionTwoFullImage() {
        selectionTwoImageview.frame.origin.x = 191
        selectionTwoImageview.frame.origin.y = 132
        selectionTwoImageview.frame.size.width = 174
        selectionTwoImageview.frame.size.height = 153
        selectionOneImageview.isHidden = false
        selectionThreeImageview.isHidden = false
        selectionFourImageview.isHidden = false
        headerLabel.isHidden = true
        footerLabel.isHidden = true
    }
    fileprivate func dismissSelectionThreeFullImage() {
        selectionThreeImageview.frame.origin.x = 9
        selectionThreeImageview.frame.origin.y = 305
        selectionThreeImageview.frame.size.width = 174
        selectionThreeImageview.frame.size.height = 153
        selectionOneImageview.isHidden = false
        selectionTwoImageview.isHidden = false
        selectionFourImageview.isHidden = false
        headerLabel.isHidden = true
        footerLabel.isHidden = true
    }
    fileprivate func dismissSelectionFourFullImage() {
        selectionFourImageview.frame.origin.x = 191
        selectionFourImageview.frame.origin.y = 305
        selectionFourImageview.frame.size.width = 174
        selectionFourImageview.frame.size.height = 153
        selectionOneImageview.isHidden = false
        selectionTwoImageview.isHidden = false
        selectionThreeImageview.isHidden = false
        headerLabel.isHidden = true
        footerLabel.isHidden = true
    }
}

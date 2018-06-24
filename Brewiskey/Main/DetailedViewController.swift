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
        let isSelectionOne = true
        let selectionViewController = DetailedSelectionViewController.fromStoryboard(name: Storyboard.Main) as! DetailedSelectionViewController
        if beerMode && isSelectionOne {
            if let beer = beer {
                selectionViewController.beer = beer
                selectionViewController.isSelectionOne = isSelectionOne
            }
            self.present(selectionViewController, animated: true)
        }
    }
    
    @objc fileprivate func selectionTwoSelected() {
        let isSelectionTwo = true
        let selectionViewController = DetailedSelectionViewController.fromStoryboard(name: Storyboard.Main) as! DetailedSelectionViewController
        if beerMode && isSelectionTwo {
            if let beer = beer {
                selectionViewController.beer = beer
                selectionViewController.isSelectionTwo = isSelectionTwo
            }
            self.present(selectionViewController, animated: true)
        }
        
    }
    
    @objc fileprivate func selectionThreeSelected() {
        let isSelectionThree = true
        let selectionViewController = DetailedSelectionViewController.fromStoryboard(name: Storyboard.Main) as! DetailedSelectionViewController
        if beerMode && isSelectionThree {
            if let beer = beer {
                selectionViewController.beer = beer
                selectionViewController.isSelectionThree = isSelectionThree
            }
            self.present(selectionViewController, animated: true)
        }
    }
    
    @objc fileprivate func selectionFourSelected() {
        let isSelectionFour = true
        let selectionViewController = DetailedSelectionViewController.fromStoryboard(name: Storyboard.Main) as! DetailedSelectionViewController
        if beerMode && isSelectionFour {
            if let beer = beer {
                selectionViewController.beer = beer
                selectionViewController.isSelectionFour = isSelectionFour
            }
            self.present(selectionViewController, animated: true)
        }
    }
    
}

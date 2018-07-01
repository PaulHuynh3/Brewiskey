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
            configureWineMode()
        }
        else if spiritMode == true {
            configureSpiritsMode()
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
    
    fileprivate func configureWineMode() {
        alcoholNameLabel.text = wine?.name
        if let selectionOneImage = wine?.imageUrl {
            selectionOneImageview.loadImagesUsingCacheWithUrlString(urlString: selectionOneImage)
        }
        selectionTwoImageview.isHidden = true
        selectionThreeImageview.isHidden = true
        selectionFourImageview.isHidden = true
    }
    
    fileprivate func configureSpiritsMode() {
        if let selectionOneImage = spirit?.smallBottleImageUrl {
            selectionOneImageview.loadImagesUsingCacheWithUrlString(urlString: selectionOneImage)
        }
        if let selectionTwoImage = spirit?.mediumBottleImageUrl {
            selectionTwoImageview.loadImagesUsingCacheWithUrlString(urlString: selectionTwoImage)
        }
        if let selectionThreeImage = spirit?.largeBottleImageUrl {
            selectionThreeImageview.loadImagesUsingCacheWithUrlString(urlString: selectionThreeImage)
        }
        selectionFourImageview.isHidden = true
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

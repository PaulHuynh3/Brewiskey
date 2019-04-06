//
//  DetailedTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-03-01.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    var isBeerMode = false
    var isWineMode = false
    var isSpiritMode = false
    var isSnackMode = false
    
    var beer: Beer?
    var wine: Wine?
    var spirit: Spirit?
    var snack: Snacks?
    private let networkRequest = NetworkRequest()
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
        if isBeerMode == true {
           configureBeerMode()
        }
        else if isWineMode == true {
            configureWineMode()
        }
        else if isSpiritMode == true {
            configureSpiritsMode()
        } else {
            configureSnackMode()
        }
    }
    
    fileprivate func configureBeerMode() {
        alcoholNameLabel.text = beer?.name
        if let selectionOneImage = beer?.singleBottle.imageUrl {
            networkRequest.loadImageFromUrl(urlString: selectionOneImage) { [weak self] (downloadImage: UIImage?, error: String?) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                    return
                }
                strongSelf.selectionOneImageview.image = downloadImage
            }
        }
        if let selectionTwoImage = beer?.singleCan.imageUrl {
            networkRequest.loadImageFromUrl(urlString: selectionTwoImage) { [weak self] (downloadImage: UIImage?, error: String?) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                    return
                }
                strongSelf.selectionTwoImageview.image = downloadImage
            }
        }
        if let selectionThreeImage = beer?.sixPackBottle.imageUrl {
            networkRequest.loadImageFromUrl(urlString: selectionThreeImage) { [weak self] (downloadImage: UIImage?, error: String?) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                    return
                }
                strongSelf.selectionThreeImageview.image = downloadImage
            }
        }
        if let selectionFourImage = beer?.sixPackCan.imageUrl {
            networkRequest.loadImageFromUrl(urlString: selectionFourImage) { [weak self] (downloadImage: UIImage?, error: String?) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                    return
                }
                strongSelf.selectionFourImageview.image = downloadImage
            }
        }
    }
    
    fileprivate func configureWineMode() {
        alcoholNameLabel.text = wine?.name
        if let selectionOneImage = wine?.imageUrl {
            networkRequest.loadImageFromUrl(urlString: selectionOneImage) { [weak self] (downloadImage: UIImage?, error: String?) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                    return
                }
                strongSelf.selectionOneImageview.image = downloadImage
            }
        }
        selectionTwoImageview.isHidden = true
        selectionThreeImageview.isHidden = true
        selectionFourImageview.isHidden = true
    }
    
    fileprivate func configureSpiritsMode() {
        alcoholNameLabel.text = spirit?.name
        if let selectionOneImage = spirit?.smallBottleImageUrl {
            networkRequest.loadImageFromUrl(urlString: selectionOneImage) { [weak self] (downloadImage: UIImage?, error: String?) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                    return
                }
                strongSelf.selectionOneImageview.image = downloadImage
            }
        }
        if let selectionTwoImage = spirit?.mediumBottleImageUrl {
            networkRequest.loadImageFromUrl(urlString: selectionTwoImage) { [weak self] (downloadImage: UIImage?, error: String?) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                    return
                }
                strongSelf.selectionTwoImageview.image = downloadImage
            }
        }
        if let selectionThreeImage = spirit?.largeBottleImageUrl {
            networkRequest.loadImageFromUrl(urlString: selectionThreeImage) { [weak self] (downloadImage: UIImage?, error: String?) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                    return
                }
                strongSelf.selectionThreeImageview.image = downloadImage
            }
        }
        selectionFourImageview.isHidden = true
    }
    
    fileprivate func configureSnackMode() {
        alcoholNameLabel.text = snack?.name
        if let selectionOneImage = snack?.imageUrl {
            networkRequest.loadImageFromUrl(urlString: selectionOneImage) { [weak self] (downloadImage: UIImage?, error: String?) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                    return
                }
                strongSelf.selectionOneImageview.image = downloadImage
            }
        }
        selectionTwoImageview.isHidden = true
        selectionThreeImageview.isHidden = true
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
        let currentSelection = 1
        handleSelection(isCorrectMode: isBeerMode, currentSelection: currentSelection)
        handleSelection(isCorrectMode: isSpiritMode, currentSelection: currentSelection)
        handleSelection(isCorrectMode: isWineMode, currentSelection: currentSelection)
        handleSelection(isCorrectMode: isSnackMode, currentSelection: currentSelection)
    }
    
    @objc fileprivate func selectionTwoSelected() {
        let currentSelection = 2
        handleSelection(isCorrectMode: isBeerMode, currentSelection: currentSelection)
        handleSelection(isCorrectMode: isSpiritMode, currentSelection: currentSelection)
    }
    
    @objc fileprivate func selectionThreeSelected() {
        let currentSelection = 3
        handleSelection(isCorrectMode: isBeerMode, currentSelection: currentSelection)
        handleSelection(isCorrectMode: isSpiritMode, currentSelection: currentSelection)
    }
    
    @objc fileprivate func selectionFourSelected() {
        let currentSelection = 4
        handleSelection(isCorrectMode: isBeerMode, currentSelection: currentSelection)
    }
    
    fileprivate func handleSelection(isCorrectMode: Bool, currentSelection: Int) {
        let selectionViewController = DetailedSelectionViewController.fromStoryboard(name: Storyboard.Main) as! DetailedSelectionViewController
        if isCorrectMode {
            if let beer = beer {
                selectionViewController.beer = beer
                selectionViewController.selectionNumber = currentSelection
                //TODO present beer/spirits/wine seprarelty because of the layout of 4 beers , 3 spirits and 1 wine.
                self.present(selectionViewController, animated: true)
            }
            if let wine = wine {
                selectionViewController.wine = wine
                selectionViewController.selectionNumber = currentSelection
                self.present(selectionViewController, animated: true)
            }
            if let spirit = spirit {
                selectionViewController.spirit = spirit
                selectionViewController.selectionNumber = currentSelection
                self.present(selectionViewController, animated: true)
            }
            if let snack = snack {
                selectionViewController.snack = snack
                selectionViewController.selectionNumber = currentSelection
                self.present(selectionViewController, animated: true)
            }
        }
    }
}

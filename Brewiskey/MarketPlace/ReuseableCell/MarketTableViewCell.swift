//
//  MarketTableViewCell.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-24.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class MarketTableViewCell: UITableViewCell {

    @IBOutlet weak var alcoholImageView: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    
    let networkRequest = NetworkRequest()
    
    func setupBeerNamesAndImages(_ beer: Beer){
        networkRequest.loadImageFromUrl(urlString: beer.singleBottle.imageUrl) { [weak self] (downloadImage: UIImage?, error: String?) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                print(error)
                return
            }
            strongSelf.alcoholImageView.image = downloadImage
        }
        brandNameLabel.text = beer.name
    }
    
    func setupSpiritNamesAndImages(_ spirit: Spirit){
        if let imageUrlString = spirit.mediumBottleImageUrl{
            networkRequest.loadImageFromUrl(urlString: imageUrlString) { [weak self] (downloadImage: UIImage?, error: String?) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                    return
                }
                strongSelf.alcoholImageView.image = downloadImage
            }
        }
        brandNameLabel.text = spirit.name
    }
    
    func setupWineNamesAndImages(_ wine: Wine){
        if let imageUrlString = wine.imageUrl {
            networkRequest.loadImageFromUrl(urlString: imageUrlString) { [weak self] (downloadImage: UIImage?, error: String?) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                    return
                }
                strongSelf.alcoholImageView.image = downloadImage
            }
        }
        brandNameLabel.text = wine.name
    }
    
    func setupSnackNamesAndImages(_ snack: Snacks){
        if let imageUrlString = snack.imageUrl {
            networkRequest.loadImageFromUrl(urlString: imageUrlString) { [weak self] (downloadImage: UIImage?, error: String?) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                    return
                }
                strongSelf.alcoholImageView.image = downloadImage
            }
        }
        brandNameLabel.text = snack.name
    }
}

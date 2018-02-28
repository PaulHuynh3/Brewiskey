//
//  MarketPlaceCollectionViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-23.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class MarketTableViewController: UITableViewController {
    var uid: String?
    var beers = NSMutableArray()
    var wines = NSMutableArray()
    var spirits = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
//        FirebaseAPI.fetchAllBeerBrandAndImages{ (beer) in
//            DispatchQueue.main.async {
//                self.beers.add(beer)
//                self.tableView.reloadData()
//            }
//        }
//        FirebaseAPI.fetchAllWineBrandAndImages { (wine) in
//            DispatchQueue.main.async {
//                self.wines.add(wine)
//                self.tableView.reloadData()
//            }
//        }
//        FirebaseAPI.fetchAllSpiritBrandAndImages { (spirit) in
//            DispatchQueue.main.async {
//                self.spirits.add(spirit)
//                self.tableView.reloadData()
//            }
//        }
        
        FirebaseAPI.fetchAllBeerBrandAndImages{ (beer) in
            FirebaseAPI.fetchAllWineBrandAndImages(completion: { (wine) in
                FirebaseAPI.fetchAllSpiritBrandAndImages(completion: { (spirit) in
                    DispatchQueue.main.async {
                        self.beers.add(beer)
                        self.wines.add(wine)
                        self.spirits.add(spirit)
                        self.tableView.reloadData()
                    }
                    
                })
            })
        }
        
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
         handleLogout()
        } else {
//            fetchUserAndSetupNavBarTitle()
        }
        
    }
    
    func handleLogout(){
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.transitionToLogin()
        }
        
    }
    
    
    // MARK: - Tableview data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count + wines.count + spirits.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as! MarketTableViewCell
        
        if indexPath.row < beers.count {
        let beer = beers[indexPath.row] as? Beer
        if let imageUrl = beer?.imageUrl{
        cell.alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
        cell.brandNameLabel.text = beer?.name
        }
    }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
    }
    

}




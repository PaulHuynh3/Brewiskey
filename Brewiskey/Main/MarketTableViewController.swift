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
        fetchAlcoholBrandsAndSetupTableview()
        
    }
    
    func fetchAlcoholBrandsAndSetupTableview(){
        FirebaseAPI.fetchAllBeerBrandAndImages{ (beer) in
            self.beers.add(beer)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        FirebaseAPI.fetchAllWineBrandAndImages { (wine) in
            self.wines.add(wine)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        FirebaseAPI.fetchAllSpiritBrandAndImages { (spirit) in
            self.spirits.add(spirit)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
         handleLogout()
        } else {
            FirebaseAPI.fetchDatabaseUsers(completion: { (user) in
                DispatchQueue.main.async {
                    self.navigationItem.title = "Welcome " + user.username!
                }
            })
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
        
        if beers.count > indexPath.row {
            let beer = beers[indexPath.row] as? Beer
            cell.brandNameLabel.text = beer?.name
            if let imageUrl = beer?.imageUrl{
            cell.alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
          }
        }  else if beers.count + wines.count > indexPath.row {
            let wine = wines[indexPath.row - self.beers.count] as? Wine
                cell.brandNameLabel.text = wine?.name
            if let imageUrl = wine?.imageUrl{
                cell.alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
            }
            
        } else if beers.count + wines.count + spirits.count > indexPath.row {
            
            let spirit = spirits[indexPath.row - self.beers.count - self.wines.count] as? Spirit
            cell.brandNameLabel.text = spirit?.name
            
            if let imageUrl = spirit?.imageUrl {
                cell.alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
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




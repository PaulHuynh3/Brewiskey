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
        fetchAlcoholBrandsAndSetupTableview()
        uid = Auth.auth().currentUser?.uid
    }

    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    
    func fetchAlcoholBrandsAndSetupTableview(){
        FirebaseAPI.fetchAllBeerBrandAndImages{ [weak self] (beer) in
            self?.beers.add(beer)
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        FirebaseAPI.fetchAllWineBrandAndImages { [weak self] (wine) in
            self?.wines.add(wine)
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        FirebaseAPI.fetchAllSpiritBrandAndImages { [weak self] (spirit) in
            self?.spirits.add(spirit)
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
         handleLogout()
        } else {
            if let firstName = UserDefaults.standard.string(forKey: kUserInfo.kFirstName), let lastName = UserDefaults.standard.string(forKey: kUserInfo.kLastName){
                self.navigationItem.title = "Welcome " + firstName + " " + lastName
            }
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
            let beer = beers[indexPath.row] as! Beer
            cell.setupBeerNamesAndImages(beer)
            
        } else if beers.count + wines.count > indexPath.row {
            let wine = wines[indexPath.row - self.beers.count] as! Wine
            cell.setupWineNamesAndImages(wine)
            
        } else if beers.count + wines.count + spirits.count > indexPath.row {
            let spirit = spirits[indexPath.row - self.beers.count - self.wines.count] as! Spirit
            cell.setupSpiritNamesAndImages(spirit)
    
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if beers.count > indexPath.row {
            let beer = beers[indexPath.row] as? Beer
            
            performSegue(withIdentifier: "beerDetailedViewSegue", sender: beer)
            
            print("beer object selected")
        }
        else if beers.count + wines.count > indexPath.row {
            let wine = wines[indexPath.row - beers.count] as? Wine
            
            performSegue(withIdentifier: "wineDetailedViewSegue", sender: wine)
            
            print("Wine object selected")
            
        } else if beers.count + wines.count + spirits.count > indexPath.row {
            let spirit = spirits[indexPath.row - beers.count - wines.count] as? Spirit
            
            performSegue(withIdentifier: "spiritDetailedViewSegue", sender: spirit)
            
           print("Spirit object selected")
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "beerDetailedViewSegue"{
            let detailedTableView = segue.destination as? DetailedTableViewController
            //the sender was set in indexpath.
            let beer = sender as? Beer
            detailedTableView?.beer = beer
            detailedTableView?.beerMode = true
        }
        
        if segue.identifier == "wineDetailedViewSegue"{
            let detailedTableView = segue.destination as? DetailedTableViewController
            let wine = sender as? Wine
            detailedTableView?.wine = wine
            detailedTableView?.wineMode = true
        }
        
        if segue.identifier == "spiritDetailedViewSegue"{
            let detailedTableView = segue.destination as? DetailedTableViewController
            let spirit = sender as? Spirit
            detailedTableView?.spirit = spirit
            detailedTableView?.spiritMode = true
        }
        
    }
    

}




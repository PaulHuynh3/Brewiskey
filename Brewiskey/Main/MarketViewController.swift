//
//  MarketViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-07-10.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class MarketViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    var uid: String?
    var beers = Array<Beer>()
    var wines = Array<Wine>()
    var spirits = Array<Spirit>()
    var searchController: UISearchController!
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "ImageLabelCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNibTableView()
        super.viewDidLoad()
        setupUI()
        fetchAlcoholProducts()
        tableView.isScrollEnabled = true
        UserDefaults.standard.set(false, forKey: kUserInfo.kNewUser)
        
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    
    fileprivate func setupUI() {
        self.tableView.tableFooterView = UIView()
    }
    
    fileprivate func fetchAllBeerProducts(completion:@escaping (Bool) -> Void) {
        FirebaseAPI().fetchAllBeerBrandAndImages{ [weak self] (beer) in
            DispatchQueue.main.async {
                self?.beers.append(beer)
                completion(true)
            }
        }
    }
    fileprivate func fetchAllWineProducts(completion:@escaping (Bool) -> Void) {
        FirebaseAPI().fetchAllWineBrandAndImages { [weak self] (wine) in
            DispatchQueue.main.async {
                self?.wines.append(wine)
                completion(true)
            }
        }
    }
    fileprivate func fetchAllSpiritProducts(completion:@escaping (Bool) -> Void) {
        FirebaseAPI().fetchAllSpiritBrandAndImages { [weak self] (spirit) in
            DispatchQueue.main.async {
                self?.spirits.append(spirit)
                completion(true)
            }
        }
    }
    fileprivate func fetchAlcoholProducts() {
        fetchAllBeerProducts { (isFinish: Bool) in
            DispatchQueue.main.async {
                if isFinish {
                    self.tableView.reloadData()
                }
            }
        }
        fetchAllSpiritProducts { (isFinish) in
            DispatchQueue.main.async {
                if isFinish {
                    self.tableView.reloadData()
                }
            }
        }
        fetchAllWineProducts { (isFinish) in
            DispatchQueue.main.async {
                if isFinish {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    fileprivate func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        }
    }
    
    fileprivate func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.transitionToLogin()
        }
    }

    fileprivate func setupNibTableView() {
        let nibName = "ImageLabelCell"
        let cell = UINib(nibName: nibName, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: cellIdentifier)
    }

    //filter arrays..
    func updateSearchResults(for searchController: UISearchController) {
       
    }
}

extension MarketViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Tableview data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count + wines.count + spirits.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as! MarketTableViewCell
        
        if beers.count > indexPath.row {
            let beer = beers[indexPath.row]
            cell.setupBeerNamesAndImages(beer)
            
        } else if beers.count + wines.count > indexPath.row {
            let wine = wines[indexPath.row - self.beers.count]
            cell.setupWineNamesAndImages(wine)
            
        } else if beers.count + wines.count + spirits.count > indexPath.row {
            let spirit = spirits[indexPath.row - self.beers.count - self.wines.count]
            cell.setupSpiritNamesAndImages(spirit)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if beers.count > indexPath.row {
            let beer = beers[indexPath.row]
            
            performSegue(withIdentifier: "beerDetailedViewSegue", sender: beer)
            
            print("beer object selected")
        }
        else if beers.count + wines.count > indexPath.row {
            let wine = wines[indexPath.row - beers.count]
            
            performSegue(withIdentifier: "wineDetailedViewSegue", sender: wine)
            
            print("Wine object selected")
            
        } else if beers.count + wines.count + spirits.count > indexPath.row {
            let spirit = spirits[indexPath.row - beers.count - wines.count]
            
            performSegue(withIdentifier: "spiritDetailedViewSegue", sender: spirit)
            
            print("Spirit object selected")
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "beerDetailedViewSegue"{
            let detailedTableView = segue.destination as? DetailedViewController
            //the sender was set in indexpath.
            let beer = sender as? Beer
            detailedTableView?.beer = beer
            detailedTableView?.isBeerMode = true
        }
        
        if segue.identifier == "wineDetailedViewSegue"{
            let detailedTableView = segue.destination as? DetailedViewController
            let wine = sender as? Wine
            detailedTableView?.wine = wine
            detailedTableView?.isWineMode = true
        }
        
        if segue.identifier == "spiritDetailedViewSegue"{
            let detailedTableView = segue.destination as? DetailedViewController
            let spirit = sender as? Spirit
            detailedTableView?.spirit = spirit
            detailedTableView?.isSpiritMode = true
        }
    }
    
}

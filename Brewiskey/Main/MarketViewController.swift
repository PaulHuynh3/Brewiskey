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
    
    var searchedBeers = Array<Beer>()
    var searchedWines = Array<Wine>()
    var searchedSpirits = Array<Spirit>()
    
    var beerMode: Bool?
    var spiritMode: Bool?
    var wineMode: Bool?
    var snacksMode: Bool?
    
    var isUsedSearch: Bool?
    var searchController: UISearchController!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var beerButton: UIButton!
    @IBOutlet weak var spiritsButton: UIButton!
    @IBOutlet weak var wineButton: UIButton!
    @IBOutlet weak var snacksButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAlcoholProducts()
        tableView.isScrollEnabled = true
        UserDefaults.standard.set(false, forKey: kUserInfo.kNewUser)
        setUpCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserLoginStatus().handleUserState()
    }
    
    fileprivate func setupUI() {
        tableView.tableFooterView = UIView()
        searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        beerMode = true
        beerButton.isSelected = true
    }
    
    //setup userdefaults here.
    fileprivate func setUpCurrentUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        FirebaseAPI.fetchDatabaseCurrentUser(uid: uid) { (user: User?) in
            UserDefaults.standard.set(user?.stripeId, forKey: kUserInfo.kStripeId)
        }
    }
    
    fileprivate func highlightSelectedButton(buttonNumber: Int){
        beerButton.isSelected = false
        spiritsButton.isSelected = false
        wineButton.isSelected = false
        snacksButton.isSelected = false
    
        if buttonNumber == 0 {
            beerButton.isSelected = true
        } else if buttonNumber == 1 {
            spiritsButton.isSelected = true
        } else if buttonNumber == 2 {
            wineButton.isSelected = true
        } else {
            snacksButton.isSelected = true
        }
    }
    
    fileprivate func configureMode(mode: String) {
        beerMode = false
        wineMode = false
        spiritMode = false
        snacksMode = false
        
        if mode == "Beer" {
            beerMode = true
        } else if mode == "Wine" {
            wineMode = true
        } else if mode == "Spirits" {
            spiritMode = true
        } else {
            snacksMode = true
        }
    }
    
    @IBAction func beerOptionTapped(_ sender: Any) {
        highlightSelectedButton(buttonNumber: 0)
            let mode = "Beer"
            configureMode(mode: mode)
            tableView.reloadData()
    }
    
    @IBAction func spiritsOptionTapped(_ sender: Any) {
        highlightSelectedButton(buttonNumber: 1)
            let mode = "Spirits"
            configureMode(mode: mode)
            tableView.reloadData()
    }
    
    @IBAction func wineOptionTapped(_ sender: Any) {
        highlightSelectedButton(buttonNumber: 2)
            let mode = "Wine"
            configureMode(mode: mode)
            tableView.reloadData()
    }
    
    @IBAction func snacksOptionTapped(_ sender: Any) {
        highlightSelectedButton(buttonNumber: 3)
        let mode = "Snack"
            configureMode(mode: mode)
            tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        if searchController.searchBar.text == nil || searchController.searchBar.text == "" {
            isUsedSearch = false
            tableView.reloadData()
            return
        }
        
        if beerMode == true {
            searchedBeers.removeAll()
            for specificBeer in beers {
                if specificBeer.name?.range(of: searchText) != nil {
                    isUsedSearch = true
                    searchedBeers.append(specificBeer)
                    tableView.reloadData()
                }
            }
        }
        
        if wineMode == true {
            searchedWines.removeAll()
            for specificWine in wines {
                if specificWine.name?.range(of: searchText) != nil {
                    isUsedSearch = true
                    searchedWines.append(specificWine)
                    tableView.reloadData()
                }
            }
        }
  
        if spiritMode == true {
            searchedSpirits.removeAll()
            for specificSpirit in spirits {
                if specificSpirit.name?.range(of: searchText) != nil {
                    isUsedSearch = true
                    searchedSpirits.append(specificSpirit)
                    tableView.reloadData()
                }
            }
        }
    }
}

extension MarketViewController {
    
    fileprivate func fetchAllBeerProducts() {
        FirebaseAPI().fetchAllBeerBrandAndImages{ [weak self] (beer) in
            DispatchQueue.main.async {
                self?.beers.append(beer)
                self?.tableView.reloadData()
            }
        }
    }
    fileprivate func fetchAllWineProducts() {
        FirebaseAPI().fetchAllWineBrandAndImages { [weak self] (wine) in
            DispatchQueue.main.async {
                self?.wines.append(wine)
            }
        }
    }
    fileprivate func fetchAllSpiritProducts() {
        FirebaseAPI().fetchAllSpiritBrandAndImages { [weak self] (spirit) in
            DispatchQueue.main.async {
                self?.spirits.append(spirit)
            }
        }
    }
    fileprivate func fetchAlcoholProducts() {
        fetchAllBeerProducts()
        fetchAllSpiritProducts()
        fetchAllWineProducts()
    }
    

}

extension MarketViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Tableview data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isUsedSearch == true {
            if beerMode == true {
                return searchedBeers.count
            } else if spiritMode == true {
                return searchedSpirits.count
            } else  {
                return searchedWines.count
            }
            
        } else if beerMode == true {
            return beers.count
        } else if spiritMode == true {
            return spirits.count
        } else {
            return wines.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MarketTableViewCell
        
        if isUsedSearch == true {
            if beerMode == true {
                let searchedBeer = searchedBeers[indexPath.row]
                cell.setupBeerNamesAndImages(searchedBeer)
            } else if spiritMode == true {
                let searchedSpirit = searchedSpirits[indexPath.row]
                cell.setupSpiritNamesAndImages(searchedSpirit)
            } else  {
                let searchedWine = searchedWines[indexPath.row]
                cell.setupWineNamesAndImages(searchedWine)
            }
        } else if beerMode == true {
            let beer = beers[indexPath.row]
            cell.setupBeerNamesAndImages(beer)
        } else if spiritMode == true {
            let spirit = spirits[indexPath.row]
            cell.setupSpiritNamesAndImages(spirit)
        } else {
            let wine = wines[indexPath.row]
            cell.setupWineNamesAndImages(wine)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isUsedSearch == true {
            if beerMode == true {
                let searchedBeer = searchedBeers[indexPath.row]
                performSegue(withIdentifier: "beerDetailedViewSegue", sender: searchedBeer)
            } else if spiritMode == true {
                let searchedSpirit = searchedSpirits[indexPath.row]
                performSegue(withIdentifier: "spiritDetailedViewSegue", sender: searchedSpirit)
            } else  {
                let searchedWine = searchedWines[indexPath.row]
                 performSegue(withIdentifier: "wineDetailedViewSegue", sender: searchedWine)
            }
        } else if beerMode == true {
            let beer = beers[indexPath.row]
             performSegue(withIdentifier: "beerDetailedViewSegue", sender: beer)
        } else if spiritMode == true {
            let spirit = spirits[indexPath.row]
            performSegue(withIdentifier: "spiritDetailedViewSegue", sender: spirit)
        } else {
            let wine = wines[indexPath.row]
            performSegue(withIdentifier: "wineDetailedViewSegue", sender: wine)
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

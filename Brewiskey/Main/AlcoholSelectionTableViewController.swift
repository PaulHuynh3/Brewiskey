//
//  AlcoholSelectionTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-03-01.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class AlcoholSelectionTableViewController: UITableViewController {
    var beer: Beer?
    var wine: Wine?
    var spirit: Spirit?
    
    var beerSelection = [String]()
    var wineSelection = [String]()
    var spiritSelection = [String]()
    
    var selectedItem: NSMutableArray!
    
    var beerMode = false
    var wineMode = false
    var spiritMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if beerMode == true{
            let firstBeerOption = "Single Beer " + (beer?.singleCanPrice)! + " " + (beer?.singleCanContent)!
            let secondBeerOption = "Six Pack Can " + (beer?.sixPackCanPrice)! + " " + (beer?.singleCanContent)! + " x6"
            
            beerSelection = [firstBeerOption, secondBeerOption, (beer?.singleBottlePrice)!, (beer?.sixPackBottlePrice)!]
        }
        if wineMode == true {
            //1 size
            let firstWineOption = (wine?.bottlePrice)! + " " + (wine?.bottleContent)!
            wineSelection = [firstWineOption]
        }
        
        if spiritMode == true {
            //3 sizes
            let firstSpiritOption = (spirit?.smallBottlePrice)! + " " + (spirit?.smallBottleContent)!
            let secondSpiritOption = (spirit?.mediumBottlePrice)! + " " + (spirit?.mediumBottleContent)!
            let thirdSpiritOption = (spirit?.largeBottlePrice)! + " " + (spirit?.largeBottleContent)!
            
            spiritSelection = [firstSpiritOption, secondSpiritOption, thirdSpiritOption]
        }
        
        //initialize the array
        selectedItem = NSMutableArray()
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if self.navigationController is MarketNavController {
            let marketNav = self.navigationController as! MarketNavController
            let user = marketNav.user
            
            user?.alcoholItems?.addObjects(from: [selectedItem])
            
            //pop to prev VC
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //want to return 5 if its beermode, reutn 3 if its spirits and 1 if its wine
        if beerMode == true {
           return beerSelection.count
        } else if wineMode == true {
           return wineSelection.count
        } else {
            return spiritSelection.count
        }
      
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        if beerMode == true{
            let beer = beerSelection[indexPath.row]
            cell.textLabel?.text = beer

            if selectedItem.contains(beer){
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        } else if wineMode == true{
            let wine = wineSelection[indexPath.row]
            cell.textLabel?.text = wine
            
            if selectedItem.contains(wine){
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        } else {
            let spirit = spiritSelection[indexPath.row]
            cell.textLabel?.text = spirit
        
            if selectedItem.contains(spirit){
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if beerMode == true {
        
            let beer = beerSelection[indexPath.row]
            
            if selectedItem.contains(beer) {
                selectedItem.remove(beer)
            } else{
                selectedItem?.add(beer)
            }
            self.tableView.reloadData()
        }
        
        if wineMode == true {
            let wine = wineSelection[indexPath.row]
            
            if selectedItem.contains(wine) {
                selectedItem.remove(wine)
            } else{
                selectedItem?.add(wine)
            }
            self.tableView.reloadData()
            
            
        }
        
        if spiritMode == true {
            let spirit = spiritSelection[indexPath.row]
            
            if selectedItem.contains(spirit) {
                selectedItem.remove(spirit)
            } else{
                selectedItem?.add(spirit)
            }
            self.tableView.reloadData()
            
        }
  
  }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shoppingCartSegue"{
            let shoppingCartViewController = segue.destination as! ShoppingCartContainerViewController
            //setting the variable as this view controller so it wont be nil when called in shoppingcartvc.
            shoppingCartViewController.alcoholSelectionTableView = self
            
        }
        
    }
    
    
    
}

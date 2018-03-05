//
//  DetailedTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-03-01.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class DetailedTableViewController: UITableViewController {
    var beerMode = false
    var wineMode = false
    var spiritMode = false
    
    var beer: Beer?
    var wine: Wine?
    var spirit: Spirit?
    
    @IBOutlet weak var alcoholImageview: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAndSetUpLabels()
 
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    func configureAndSetUpLabels(){
        if beerMode == true{
            if let imageUrl = beer?.imageUrl{
                alcoholImageview.loadImagesUsingCacheWithUrlString(urlString:imageUrl)
            }
            countryLabel.text = beer?.country
        }
        else if wineMode == true {
            if let imageUrl = wine?.imageUrl{
                alcoholImageview.loadImagesUsingCacheWithUrlString(urlString:imageUrl)
            }
            countryLabel.text = wine?.country
        }
        else if spiritMode == true {
            if let imageUrl = spirit?.imageUrl{
                alcoholImageview.loadImagesUsingCacheWithUrlString(urlString:imageUrl)
            }
            countryLabel.text = spirit?.country
        }
        
    }
    
    
    @IBAction func dropDownButtonTapped(_ sender: Any) {
        //setting the sender as the object
        if beerMode == true {
        performSegue(withIdentifier: "beerDropDownSegue", sender: beer)
        }
        else if wineMode == true {
        performSegue(withIdentifier: "wineDropDownSegue", sender: wine)
        }
        else if spiritMode == true{
        performSegue(withIdentifier: "spiritDropDownSegue", sender: spirit)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //using the set sender to segue to dropdown vc.
        if segue.identifier == "beerDropDownSegue"{
            let alcoholSelectionTable = segue.destination as! AlcoholSelectionTableViewController
            let beer = sender as? Beer
            alcoholSelectionTable.beerMode = true
            alcoholSelectionTable.beer = beer
        }
        if segue.identifier == "wineDropDownSegue"{
            let alcoholSelectionTable = segue.destination as! AlcoholSelectionTableViewController
            let wine = sender as? Wine
            alcoholSelectionTable.wineMode = true
            alcoholSelectionTable.wine = wine
        }
        if segue.identifier == "spiritDropDownSegue"{
            let alcoholSelectionTable = segue.destination as! AlcoholSelectionTableViewController
            let spirit = sender as? Spirit
            alcoholSelectionTable.spiritMode = true
            alcoholSelectionTable.spirit = spirit
        }
        
      
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }



}

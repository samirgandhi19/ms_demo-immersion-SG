//
//  PurchaseListTableViewController.swift
//  Recommendations
//
//  Created by Alan Cota on 8/7/17.
//  Copyright © 2017 CA Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PurchaseListTableViewController: UITableViewController, URLSessionDelegate {

    // MARK: - Class Properties
    
    // User Defaults to define some demo information
    let defaults = UserDefaults.standard
    
    // Customer Number received from the customer picker screen
    var customerNumber = ""
    // Object to receive the purchases and recommendations JSON
    var purchasesList = [PurchaseListObject]()

    //
    // MARK: - main loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.title = "Your recommendations"
        
        getPurchases()

    }
}

extension PurchaseListTableViewController {
    //
    // MARK: - Call the Recommendation API to pull off the JSON with purchases and recommendations
    func getPurchases() {
        
        let access_token = defaults.string(forKey: "access_token")!
        print ("Access token used: \(access_token)")
        
        // Secure Experience - using access_token
        let urlRequest = Common.Demo.demoAPIOTKCustomerPurchasesBeforeCustomerNumber + customerNumber + Common.Demo.demoAPICustomerPurchasesAfterCustomerNumber+"?access_token=\(access_token)"
        
        print ("URL------> \(urlRequest)")
        
        // Uses third party Alamofire framework to make the API Call
        Networking.manager.request(urlRequest, method: .get).validate().responseJSON { response in
            
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                print("Purchases JSON: \(json)")
                print("Starting the loop...")
                
                var count = 0
                for (key,subJson):(String, JSON) in json {
                    self.purchasesList.append(PurchaseListObject(pItem: key, pRec: subJson.rawValue as! [String]))
                    count += 1
                }
                
            case .failure(let error):
                print(error)
            }
            
            // Force the tableView to reload and use the new purchaseList dictionary
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            self.tableView.reloadData()
            
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.purchasesList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // return self.purchasesList[section].recommendations.count
        return self.purchasesList[section].collapsed ? 0: self.purchasesList[section].recommendations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecommendationsTableViewCell
        
        let cell: RecommendationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RecommendationsTableViewCell ??
            RecommendationsTableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.lblCell.text = self.purchasesList[indexPath.section].recommendations[indexPath.row]
    
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    // Header
     override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? PurchaseListTableViewHeaderFooterView ?? PurchaseListTableViewHeaderFooterView(reuseIdentifier: "header")
        
        header.titleLabel.text = self.purchasesList[section].item
        header.arrowLabel.text = ">"
        header.setCollapsed(self.purchasesList[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
}

//
// MARK: - Section Header Delegate
//
extension PurchaseListTableViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: PurchaseListTableViewHeaderFooterView, section: Int) {
        let collapsed = !self.purchasesList[section].collapsed
        
        // Toggle collapse
        self.purchasesList[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
}

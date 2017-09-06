//
//  AddRecommendationViewController.swift
//  Recommendations
//
//  Created by Alan Cota on 8/11/17.
//  Copyright © 2017 CA Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AddRecommendationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // Class properties
    @IBOutlet weak var txtRecProdCode: UITextField!
    @IBOutlet weak var txtRecProdName: UITextField!
    @IBOutlet weak var btnCallAPI: UIButton!
    @IBOutlet weak var pickerProducts: UIPickerView!
    
    // Products array
    var productList = [ProductObject]()
    var selectedIndex = 0
    var selectedProduct = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Connect PickerList to its data
        self.pickerProducts.dataSource = self
        self.pickerProducts.delegate = self
        
        // Call the function to get the list of products and use is as the pickerList
        getProducts()
    }

    @IBAction func btnCallAPITapped(_ sender: Any) {
        
        addRecommendation()
        
    }
    
    // PickerView delegate methods
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.productList.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.productList.sort { $0.productName < $1.productName }
        let product = self.productList[row]
        selectedIndex = row
        
        
        
        // Here you can present either the productCode or the productName within the picker list
        return product.productName
    }
    
    // Change the picker view font and its color
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = self.productList[row].productName
        let myTitle = NSAttributedString(string: titleData!, attributes: [NSFontAttributeName:UIFont(name: "Verdana", size: 9.0)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedProduct = self.productList[row].productCode!
        self.selectedIndex = row
        print("Selected row \(self.selectedIndex): \(self.selectedProduct)")
    }
    
    // Function to make a POST to the LAC Recommendations table API
    func addRecommendation() {
        
        
        let httpParams = ["productCode":self.selectedProduct, "r_productCode":txtRecProdCode.text!, "r_productName":txtRecProdName.text!]
        
        print(httpParams)
        
        let httpHeaders: HTTPHeaders = [
            Common.Demo.demoAPICustomerListAuthHeader: Common.Demo.demoAPIRecommendationAuthHeaderValue,
            "Accept": "application/json",
            "Content-Type":"application/json"
        ]

        SVProgressHUD.show(withStatus: "Adding the new recommendation, please wait...")
        Alamofire.request(Common.Demo.demoAPIRecommendation, method: .post, parameters: httpParams, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { response in
        
            SVProgressHUD.dismiss()
            
            switch (response.result) {
            case .success(let _):
                print("Recommendation added!")
                
                // Success
                let alertController = UIAlertController(title: "Add new recommendation", message: Common.Dialogs.newRecommendation + " \(self.productList[self.selectedIndex].productName!) - code (\(self.productList[self.selectedIndex].productCode!))", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                    
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                    
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                
            case .failure(let error):
                print("Error adding recommendation >>> \(error)")
                
                // Error
                let alertController = UIAlertController(title: "Error", message: Common.Error.error1001 + " - [\(error)]", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                }
                
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
            
        }
        }

    
    }
    
    // Func to grab the list of products and present as a picker list
    func getProducts() {
        
        SVProgressHUD.show(withStatus: "Fetching the products list, please wait...")
        let headers: HTTPHeaders = [
            Common.Demo.demoAPICustomerListAuthHeader: Common.Demo.demoAPIRecommendationAuthHeaderValue,
            "Accept": "application/json"
        ]
        
        Alamofire.request(Common.Demo.demoAPIProducts, method: .get, headers: headers).validate().responseJSON { response in
            
            SVProgressHUD.dismiss()
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                //Loop to build out the item selector (picker)
                for (key,subJson):(String, JSON) in json {
                    self.productList.append(ProductObject(json: subJson))
                }
                
                // Sorting the productList object alphabecitally
                self.productList.sort(by: { ($0.productName < $1.productName) })
                
                self.pickerProducts.reloadAllComponents()
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}

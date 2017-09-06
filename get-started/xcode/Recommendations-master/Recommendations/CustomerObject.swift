//
//  CustomerObject.swift
//  Recommendations
//
//  Created by Alan Cota on 8/4/17.
//  Copyright © 2017 CA Technologies. All rights reserved.
//


import SwiftyJSON

class CustomerObject {
    
    var customerName: String!
    var customerNumber: String!
    
    required init(json: JSON) {
        customerNumber = json["customerNumber"].stringValue
        customerName = json["customerName"].stringValue
    }
    
}

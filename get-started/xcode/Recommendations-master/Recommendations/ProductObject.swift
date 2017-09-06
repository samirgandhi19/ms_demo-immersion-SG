//
//  ProductObject.swift
//  Recommendations
//
//  Created by Alan Cota on 8/14/17.
//  Copyright © 2017 CA Technologies. All rights reserved.
//

import SwiftyJSON

class ProductObject: CustomStringConvertible, Comparable {
    
    var productCode: String!
    var productName: String!
    var description: String { return productName }
    
    required init (json: JSON) {
        
        productCode = json["productCode"].stringValue
        productName = json["productName"].stringValue
        
    }
    
    static func ==(lhs: ProductObject, rhs: ProductObject) -> Bool {
        return lhs.productName == rhs.productName
    }
    
    static func <(lhs: ProductObject, rhs: ProductObject) -> Bool {
        return lhs.productName < rhs.productName
    }
    
}

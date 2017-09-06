//
//  PurchaseListObject.swift
//  Recommendations
//
//  Created by Alan Cota on 8/10/17.
//  Copyright © 2017 CA Technologies. All rights reserved.
//

import Foundation

class PurchaseListObject {
    
    var item: String!
    var recommendations: [String]!
    var collapsed: Bool
    
    required init (pItem: String, pRec: [String], pCollapsed: Bool = false) {
        item = pItem
        recommendations = pRec
        collapsed = pCollapsed
    }
    
}

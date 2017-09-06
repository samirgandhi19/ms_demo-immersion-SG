//
//  Common.swift
//  Recommendations
//
//  Created by Alan Cota on 8/4/17.
//  Copyright © 2017 CA Technologies. All rights reserved.
//
//  This class is used to configure your demo experience
//

import UIKit

class Common: NSObject {

   //Demo Configuration
    struct Demo {
        // List of users to be picked at the user selection screen
        static let demoUserPickList = ["Alan", "Daniel", "Alana"]
        
        // LAC API used to fetch a list of all customers and their respective number
        static let demoAPICustomerList = "http://localhost:8111/rest/default/svcOrders/v1/orders:customers"

        // Customer API authorization header name
        static let demoAPICustomerListAuthHeader = "Authorization"
        
        // Customer API authorization header value
        static let demoAPICustomerListAuthHeaderValue = "CALiveAPICreator zFeg53T5ESosM2xqM86s:1"
        
        // API to retrieve the purchases of a specific customerNumber - Below the URI BEFORE the customerNumber
        static let demoAPICustomerPurchasesBeforeCustomerNumber = "http://localhost:8080/recSvc/v1/users/"
        
        // API to retrieve the purchases of a specific customerNumber - Below the URI BEFORE the customerNumber
        static let demoAPIOTKCustomerPurchasesBeforeCustomerNumber = "https://localhost:443/recSvc/v1/users/"
        
        // API to retrieve the purchases of a specific customerNumber - Below the URI AFTER the customerNumber
        static let demoAPICustomerPurchasesAfterCustomerNumber = "/orders"
        
        // Name of the image used inside the recommendation's tableview. It MUST match the name inside the Assets.xcassets
        static let demoRecommendationImage = "recommendation"
        
        // Main Screen Buttons
        static let demoMainButtonSecure = "Secure"
        static let demoMainButtonUnsecure = "Unsecure"
        
        // User Defaults Key for the secure or unsecure demo experience
        static let demoExperienceDefaultsKey = "secure"
        
        // LAC Recommendation table backend API
        static let demoAPIRecommendation = "http://localhost:8111/rest/default/svcRecs/v1/rec:recommendations"
        
        // LAC Recommendation table backend Admin Token
        static let demoAPIRecommendationAuthHeaderValue = "CALiveAPICreator Y1tmNkYbxu5t93ixTCtJ:1"
        
        // LAC Products table backend API
        static let demoAPIProducts = "http://localhost:8111/rest/default/svcRecs/v1/rec:products"
    }
    
    //OAuth Information to obtain an access_token
    struct OAuth {
        
        // Token Endpoint
        static let oauthTokenEndpoint = "https://localhost:8443/auth/oauth/v2/token"
        
        // Parameter: client_id
        static let oauthClientId = "clientkey"
        
        // Parameter: client_secret
        static let oauthClientSecret = "clientsecret"
        
        // Parameter: scope
        static let oauthScope = "oob"
        
        // Parameter: grant_type
        static let oauthGrantType = "password"
        
        // Parameter: username
        static let oauthUsername = "arose"
        
        // Parameter: password
        static let oauthPassword = "StRonG5^)"
        
    }
    
    // Error codes
    struct Error {
        
        // Error 1001: Adding recommendation
        static let error1001 = "[1001] - Add new recommendation:"
    }
    
    // User Dialogs
    struct Dialogs {
        
        // New Recommendation successfully added
        static let newRecommendation = "New recommendation successfully added to the product:"
        
    }
}

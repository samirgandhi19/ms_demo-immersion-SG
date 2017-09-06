//
//  Networking.swift
//  Recommendations
//
//  Created by Alan Cota on 8/10/17.
//  Copyright © 2017 CA Technologies. All rights reserved.
//

import Foundation
import Alamofire

class Networking {
    
    static let manager: SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            
            "localhost:8443": .disableEvaluation,
            "localhost:443": .disableEvaluation,
            "otk.mycompany.com:443" : .disableEvaluation,
            "otk.mycompany.com:8443" : .disableEvaluation
        ]
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        return Alamofire.SessionManager(configuration: configuration,
          serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }()
    
}

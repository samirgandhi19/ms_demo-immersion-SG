//
//  MainViewController.swift
//  Recommendations
//
//  Created by Alan Cota on 8/10/17.
//  Copyright © 2017 CA Technologies. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // Class properties
    
    // User Defaults to define some demo information
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Prepare to segue to configure the demo experience
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        // Secure Demo Experience
//        if segue.identifier == "secureDemoExperience" {
//            defaults.set(true, forKey: Common.Demo.demoExperienceDefaultsKey)
//        }
//        
//        // Unsecure Demo Experience
//        if segue.identifier == "unsecureDemoExperience" {
//            defaults.set(false, forKey: Common.Demo.demoExperienceDefaultsKey)
//        }
//        
//    }
}

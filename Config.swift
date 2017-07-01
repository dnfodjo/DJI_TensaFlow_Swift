//
//  Config.swift
//  ARAJOY
//
//  Created by Daniel Nfodjo on 7/1/17.
//  Copyright © 2017 Daniel Nfodjo. All rights reserved.
//

import UIKit

class Config {

    
    // Lower the confidence if the app doesn't recognize your objects easily
    // Increase if it doesn't recognize correctly
    
    static var confidence = 0.1
    
    
    // For every object you train, add a URL that should be opened when the app sees that object
 
    static var seeThisOpenThat:[String:String] = [
          "catch-all" : "https://google.com/search?q=%s%20cable",
        // the label will be added to the end of the catch-all string
        
        // Add your specific labels here if you need to:
        "macbook"    : "https://google.com/search?q=macbook",
    ]
    
    
}

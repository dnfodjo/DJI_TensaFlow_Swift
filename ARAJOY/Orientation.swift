//
//  Orientation.swift
//  ARAJOY
//
//  Created by Daniel Nfodjo on 7/1/17.
//  Copyright © 2017 Daniel Nfodjo. All rights reserved.
//

import Foundation
import UIKit
struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}

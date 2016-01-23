//
//  KeyboardDismisser.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-23.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class KeyboardDismisser  {
 
    let vc: UIViewController
    
    init(viewController: UIViewController) {
        self.vc = viewController
        
        // set up tap recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.vc.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleSingleTap(recognizer: UITapGestureRecognizer) {
        vc.view.endEditing(true)
    }
    
}

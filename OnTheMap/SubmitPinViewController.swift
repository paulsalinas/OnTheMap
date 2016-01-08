//
//  SubmitPinViewController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-06.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import MapKit

class SubmitPinViewController: UIViewController {
    
    var rootPresentingController: UIViewController!
    var location: CLLocation?
    
    @IBOutlet weak var enterLinkTextView: UITextView!
    
    // strong reference to the delegate
    var placeHolderDelegate: PlaceHolderTextViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeHolderDelegate = PlaceHolderTextViewDelegate(placeHolder: enterLinkTextView.text)
        enterLinkTextView.delegate = placeHolderDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        
        // we need to dismiss at the root to also dismiss all of the modals that may have presented this one
        rootPresentingController.dismissViewControllerAnimated(true, completion: nil)
    }

}

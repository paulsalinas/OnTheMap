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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        
        // we need to dismiss at the root to also dismiss all of the modals that may have presented this one
        rootPresentingController.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

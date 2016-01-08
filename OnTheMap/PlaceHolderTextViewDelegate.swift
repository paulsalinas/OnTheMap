//
//  PlaceHolderTextViewDelegate.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-07.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class PlaceHolderTextViewDelegate: NSObject, UITextViewDelegate {
    
    // the delegate needs to know the placeholder value in order for this to work
    let placeHolder: String!
    
    init(placeHolder: String!) {
        self.placeHolder = placeHolder
    }
    
    func textViewDidBeginEditing(textView: UITextView)  {
        
        // check if the placeholder is there, if so if they begin editing we need to reset the text for them
        if placeHolder == textView.text {
            textView.text = ""
            textView.textAlignment = NSTextAlignment.Left
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        // if the user tried to enter text but ended up not editing anything, revert back to placeholder
        if textView.text == nil || textView.text == "" {
            textView.text = placeHolder
            textView.textAlignment = NSTextAlignment.Center
        }
    }

}

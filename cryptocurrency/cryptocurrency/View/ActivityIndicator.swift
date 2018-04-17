//
//  ActivityIndicatorController.swift
//  AloOpen
//
//  Created by Khoa Nguyen on 2/2/18.
//  Copyright © 2018 KhoaNguyen. All rights reserved.
//

import UIKit

class ActivityIndicator{
    static var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    static func startActivity(viewController:UIViewController){
        activityIndicator.center = viewController.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        viewController.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    static func stopActivity(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}

//
//  AlertController.swift
//  AloOpen
//
//  Created by Khoa Nguyen on 1/30/18.
//  Copyright © 2018 KhoaNguyen. All rights reserved.
//

import UIKit

class Alert{
    static func showAlert(inViewController:UIViewController, title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        inViewController.present(alert, animated: true, completion: nil)
    }
}


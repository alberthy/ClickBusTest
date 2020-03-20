//
//  Alert.swift
//  ClickBusTest
//
//  Created by Albert Oliveira on 20/03/20.
//  Copyright © 2020 Albert Oliveira. All rights reserved.
//

import UIKit

class Alert {
    
    let viewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func show(_ title: String = "Alerta", message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func show(_ title: String = "Alerta", message : String, cancelAction: UIAlertAction, doAction: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(doAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func show(_ title: String = "Alerta", message : String, okAction: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
}

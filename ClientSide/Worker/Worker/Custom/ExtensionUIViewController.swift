//
//  ExtentionUIViewController.swift
//  Worker
//
//  Created by TONY on 28/06/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    func setUpDoneButton() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: true)
        
        return toolBar
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    func alertError(message: String) -> Void {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
}

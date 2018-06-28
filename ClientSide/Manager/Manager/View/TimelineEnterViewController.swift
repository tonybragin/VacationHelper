//
//  TimelineEnterViewController.swift
//  Manager
//
//  Created by TONY on 17/04/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import UIKit

class TimelineEnterViewController: UIViewController {
    
    @IBOutlet weak var textPeriod: UITextField!
    
    @IBAction func actionEnter(_ sender: UIButton) {
        
        if textPeriod.text == "" {
            alertError(message: "Write period!")
            return
        }
        
        if !isValid(string: textPeriod.text!) {
            alertError(message: "Wrong period!\n(YYYY-MM)")
            return
        }
        
        self.performSegue(withIdentifier: "TimelineEnterToTimeline", sender: textPeriod.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textPeriod.inputAccessoryView = setUpDoneButton()
        textPeriod.keyboardType = .asciiCapable

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? TimelineTableViewController {
            
            controller.period = sender! as! String
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func isValid (string: String) -> Bool {
        if string.count != 7 {
            return false
        }
        let str = Array(string)
        if str[4] != "-" {
            return false
        }
        let month = Int("\(str[5])\(str[6])")!
        if month > 12 || month < 1 {
            return false
        }
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */

}

//
//  EnterViewController.swift
//  Manager
//
//  Created by TONY on 17/04/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import UIKit

var DEPARTMENT: String = ""

class EnterViewController: UIViewController {

    @IBOutlet weak var textDepartment: UITextField!
    
    @IBAction func actionEnter(_ sender: UIButton) {
        
        if textDepartment.text == "" {
            alertError(message: "Write Department!")
            return
        }
        
        //DEPARTMENT = textDepartment.text!
        WORKER.department = textDepartment.text!
        
        isDepartmentExist()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textDepartment.inputAccessoryView = setUpDoneButton()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isDepartmentExist() {
        
        guard let url = URL(string: "http://0.0.0.0:1234/workers?department=\(WORKER.department)")
            else {
                self.alertError(message: "Text can't have spaces")
                return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                OperationQueue.main.addOperation {
                    self.alertError(message: "Something wrong with connection")
                    return
                }
                return
            }
            
            guard let loadData = data else {
                print("error no data response")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: loadData, options: []) as! NSArray
                
                if let _ = (json.firstObject as? NSDictionary)?.value(forKey: "department") as? String {
                    
                    OperationQueue.main.addOperation {
                        self.performSegue(withIdentifier: "EnterToMenu", sender: nil)
                    }
                } else {
                    OperationQueue.main.addOperation {
                        self.alertError(message: "Wrong Department!")
                        return
                    }
                    return
                }
                
            } catch {
                print("error trying to convert data to JSON2")
                return
            }
        }
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

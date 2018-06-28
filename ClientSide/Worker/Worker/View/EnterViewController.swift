//
//  EnterViewController.swift
//  Worker
//
//  Created by TONY on 17/04/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import UIKit

class EnterViewController: UIViewController {

    @IBOutlet weak var textId: UITextField!
    
    @IBAction func actionEnter(_ sender: UIButton) {
        
        if textId.text == "" {
            alertError(message: "Write ID!")
            return
        }
        
        WORKER.workerId = Int(textId.text!)!
        
        isWorker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textId.inputAccessoryView = setUpDoneButton()
        textId.keyboardType = .numberPad

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isWorker() {
        guard let url = URL(string: "http://0.0.0.0:1234/worker/?id=\(WORKER.workerId)")
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
                
                if let department = (json.firstObject as? NSDictionary)?.value(forKey: "department") as? String {
                    
                    OperationQueue.current?.addOperation {
                        WORKER.department = department
                        WORKER.hireDate = ((json.firstObject as? NSDictionary)?.value(forKey: "hire_date") as! String)
                        WORKER.vacationDaysHave = ((json.firstObject as? NSDictionary)?.value(forKey: "vacation_days_had") as! Int)
                    }
                    OperationQueue.main.addOperation {
                        self.performSegue(withIdentifier: "EnterToMenu", sender: nil)
                    }
                } else {
                    OperationQueue.main.addOperation {
                        self.alertError(message: "Wrong ID!")
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

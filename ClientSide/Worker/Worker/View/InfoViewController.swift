//
//  InfoViewController.swift
//  Worker
//
//  Created by TONY on 17/04/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import UIKit
import Foundation

class InfoViewController: UIViewController {

    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelDepartment: UILabel!
    @IBOutlet weak var labelHireDate: UILabel!
    @IBOutlet weak var labelVacationDaysHad: UILabel!
    @IBOutlet weak var labelVacationDaysHave: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func printInfo(json: NSArray) {
        let worker = json.firstObject as! NSDictionary
        
        self.labelFirstName.text = (worker.value(forKey: "first_name") as! String)
        self.labelLastName.text = (worker.value(forKey: "last_name") as! String)
        self.labelDepartment.text = (worker.value(forKey: "department") as! String)
        
        let hireDate = (worker.value(forKey: "hire_date") as! String)
        self.labelHireDate.text = hireDate
        
        let vacationDaysHad = worker.value(forKey: "vacation_days_had") as! Int
        self.labelVacationDaysHad.text = "\(vacationDaysHad)"
        
        self.calculateVacationDaysHave(hireDate: hireDate, vacationDaysHad: vacationDaysHad)
    }
    
    func loadInfo() {
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
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: loadData, options: []) as! NSArray
                OperationQueue.main.addOperation {
                    self.printInfo(json: json)
                }
            } catch { return }
        }
        task.resume()
    }
    
    func calculateVacationDaysHave (hireDate: String, vacationDaysHad: Int) {
        guard let url = URL(string: "http://0.0.0.0:1234/calculate_vacation?hire_date=\(hireDate)")
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
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                
                OperationQueue.main.addOperation {
                    let responseDays = ((json.firstObject as! NSDictionary).value(forKey: "?column?") as! Double)
                    let vacationDaysHave = lround(responseDays * 0.077) - vacationDaysHad
                    self.labelVacationDaysHave.text = "\(vacationDaysHave)"
                }
            } catch {
                print("error trying to convert data to JSON")
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

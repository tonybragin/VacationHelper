//
//  MakeRequestViewController.swift
//  Worker
//
//  Created by TONY on 17/04/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import UIKit

class MakeRequestViewController: UIViewController {

    @IBOutlet weak var textDateStart: UITextField!
    @IBOutlet weak var textDateEnd: UITextField!
    
    var vacationDaysRequest: Int = 0
    
    @IBAction func actionEnter(_ sender: UIButton) {
        let dateStart = textDateStart.text!
        let dateEnd  = textDateEnd.text!
        
        if dateStart == "" || dateEnd == "" {
            alertError(message: "Must fill both text field!")
            return
        }
        
        if !isValid(string: dateStart) || !isValid(string: dateEnd) {
            alertError(message: "Wrong dates!\n(YYYY-MM-DD)")
            return
        }
        
        let period = isItOnePeriod(from: dateStart, dateEnd: dateEnd)
        
        switch period {
        case "-":
            alertError(message: "Looks like dates mixed up")
            return
        case "":
            alertError(message: "Dates ain't from one period")
            return
        default:
            canWorkerTakeVacation(period: period, dateStart: dateStart, dateEnd: dateEnd)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textDateStart.inputAccessoryView = setUpDoneButton()
        textDateEnd.inputAccessoryView = setUpDoneButton()
        
        textDateStart.keyboardType = .asciiCapable
        textDateEnd.keyboardType = .asciiCapable

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValid (string: String) -> Bool {
        if string.count != 10 {
            return false
        }
        let str = Array(string)
        if str[4] != "-" || str[7] != "-" {
            return false
        }
        let year = Int("\(str[0])\(str[1])\(str[2])\(str[3])")!
        let month = Int("\(str[5])\(str[6])")!
        let day = Int("\(str[8])\(str[9])")!
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            if day < 1 || day > 31 {
                return false
            } else {
                return true
            }
        case 4, 6, 9, 11:
            if day < 1 || day > 30 {
                return false
            } else {
                return true
            }
        case 2:
            if year % 4 == 0 {
                if day < 1 || day > 29 {
                    return false
                } else {
                    return true
                }
            } else {
                if day < 1 || day > 28 {
                    return false
                } else {
                    return true
                }
            }
        default:
            return false
        }
    }
    
    func isItOnePeriod(from dateStart: String, dateEnd: String) -> String {
        var period: String = ""
        let strStart = Array(dateStart)
        let strEnd = Array(dateEnd)
        let yearStart = Int("\(strStart[0])\(strStart[1])\(strStart[2])\(strStart[3])")!
        let yearEnd = Int("\(strEnd[0])\(strEnd[1])\(strEnd[2])\(strEnd[3])")!
        let monthStart = Int("\(strStart[5])\(strStart[6])")!
        let monthEnd = Int("\(strEnd[5])\(strEnd[6])")!
        let dayStart = Int("\(strStart[8])\(strStart[9])")!
        let dayEnd = Int("\(strEnd[8])\(strEnd[9])")!
        if (dayEnd - dayStart) < 1 {
            return "-"
        } else {
            vacationDaysRequest = dayEnd - dayStart
        }
        if yearStart != yearEnd || monthStart != monthEnd {
            return period
        } else {
            if monthStart > 9 {
                period = "\(yearStart)-\(monthStart)"
            } else {
                period = "\(yearStart)-0\(monthStart)"
            }
            return period
        }
    }
    
    func postRequest (period: String, dateStart: String, dateEnd: String) {
        let params = ["id": WORKER.workerId, "department": WORKER.department, "period": period, "date_start": dateStart, "date_end": dateEnd] as [String : Any]
        guard let url = URL(string: "http://0.0.0.0:1234/request/new")
            else {
                self.alertError(message: "Text can't have spaces")
                return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let session = URLSession.shared
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options:[])
        } catch {}
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: urlRequest)
        task.resume()
    }
    
    func canWorkerTakeVacation (period: String, dateStart: String, dateEnd: String) {
        guard let url = URL(string: "http://0.0.0.0:1234/calculate_vacation?hire_date=\(WORKER.hireDate)")
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
                    let vacationDaysHave = lround(responseDays * 0.077) - WORKER.vacationDaysHave
                    if self.vacationDaysRequest > vacationDaysHave  {
                        self.alertError(message: "You don't have that much days")
                        return
                    } else {
                        self.postRequest(period: period, dateStart: dateStart, dateEnd: dateEnd)
                        self.navigationController?.popViewController(animated: true)
                    }
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

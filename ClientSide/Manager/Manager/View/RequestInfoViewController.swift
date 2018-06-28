//
//  RequestInfoViewController.swift
//  Manager
//
//  Created by TONY on 17/04/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import UIKit

class RequestInfoViewController: UIViewController {

    @IBOutlet weak var labelIdWorker: UILabel!
    @IBOutlet weak var labelPeriod: UILabel!
    @IBOutlet weak var labelDates: UILabel!
    @IBOutlet weak var buttonAccept: UIButton!
    @IBOutlet weak var buttonNo: UIButton!
    
    var request: NSDictionary = [:]
    
    @IBAction func actionAccept(_ sender: UIButton) {
        
        putRequestStatus(with: "accept")
        OperationQueue.main.addOperation {
            self.postNewTimeline()
        }
        OperationQueue.main.addOperation {
            self.putChangesToVacationDaysHad()
        }
        
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionNo(_ sender: UIButton) {
        
        putRequestStatus(with: "no")
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelIdWorker.text = "\((request.value(forKey: "id_worker") as! Int))"
        self.labelPeriod.text = (request.value(forKey: "period") as! String)
        self.labelDates.text = (request.value(forKey: "date_start") as! String) + "\n" + (request.value(forKey: "date_end") as! String)
        
        if (request.value(forKey: "status") as! String) != "in work" {
            self.buttonAccept.isHidden = true
            self.buttonNo.isHidden = true
        } else {
            self.buttonAccept.isHidden = false
            self.buttonNo.isHidden = false
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func putRequestStatus(with string: String) {
        let params = ["id": (request.value(forKey: "id") as! Int), "status": string] as [String : Any]
        guard let url = URL(string: "http://0.0.0.0:1234/update_request_status")
            else {
                self.alertError(message: "Text can't have spaces")
                return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        let session = URLSession.shared
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {}
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: urlRequest)
        task.resume()
    }
    
    func calculateVacationDays() -> Int {
        let strStart = Array(request.value(forKey: "date_start") as! String)
        let strEnd = Array(request.value(forKey: "date_end") as! String)
        
        let dayStart = Int("\(strStart[8])\(strStart[9])")!
        let dayEnd = Int("\(strEnd[8])\(strEnd[9])")!
        
        return dayEnd - dayStart
    }
    
    func postNewTimeline() {
        let paramsForNewTimelinePost = ["period": request.value(forKey: "period")!, "department": request.value(forKey: "department")!, "id_worker": (request.value(forKey: "id_worker") as! Int), "date_start": request.value(forKey: "date_start")!, "date_end": request.value(forKey: "date_end")!] as [String : Any]
        
        guard let urlForNewTimelinePost = URL(string: "http://0.0.0.0:1234/timeline/new")
            else {
                self.alertError(message: "Text can't have spaces")
                return
        }
        
        var urlRequestForNewTimelinePost = URLRequest(url: urlForNewTimelinePost)
        urlRequestForNewTimelinePost.httpMethod = "POST"
        let sessionForNewTimelinePost = URLSession.shared
        
        do {
            urlRequestForNewTimelinePost.httpBody = try JSONSerialization.data(withJSONObject: paramsForNewTimelinePost, options: [])
        } catch {}
        
        urlRequestForNewTimelinePost.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let taskForNewTimelinePost = sessionForNewTimelinePost.dataTask(with: urlRequestForNewTimelinePost)
        taskForNewTimelinePost.resume()
    }
    
    func putChangesToVacationDaysHad() {
        let paramsForUpdateVacationDaysHad = ["id": (request.value(forKey: "id_worker") as! Int), "days": calculateVacationDays()] as [String : Any]
        
        guard let urlForUpdateVacationDaysHad = URL(string: "http://0.0.0.0:1234/worker_had_vacation")
            else {
                self.alertError(message: "Text can't have spaces")
                return
        }
        
        var urlRequestForUpdateVacationDaysHad = URLRequest(url: urlForUpdateVacationDaysHad)
        urlRequestForUpdateVacationDaysHad.httpMethod = "PUT"
        let sessionForUpdateVacationDaysHad = URLSession.shared

        do {
            urlRequestForUpdateVacationDaysHad.httpBody = try JSONSerialization.data(withJSONObject: paramsForUpdateVacationDaysHad, options: [])
        } catch {}
        
        urlRequestForUpdateVacationDaysHad.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let taskForUpdateVacationDaysHad = sessionForUpdateVacationDaysHad.dataTask(with: urlRequestForUpdateVacationDaysHad)
        taskForUpdateVacationDaysHad.resume()
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

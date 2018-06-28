//
//  WorkersTableViewController.swift
//  Manager
//
//  Created by TONY on 17/04/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import UIKit

class WorkersTableViewController: UITableViewController {

    @IBOutlet var tableWorkers: UITableView!
    
    var workers: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableWorkers.tableFooterView = UIView()
        
        loadWorkers()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableWorkers.dequeueReusableCell(withIdentifier: "WorkersCell", for: indexPath) as! WorkersCell
        
        cell.labelIdWorker.text = "\(((workers.value(forKey: "id_worker") as! NSArray).object(at: indexPath.row) as! Int))"
        cell.labelFirstName.text = ((workers.value(forKey: "first_name") as! NSArray).object(at: indexPath.row) as! String)
        cell.labelLastName.text = ((workers.value(forKey: "last_name") as! NSArray).object(at: indexPath.row) as! String)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let worker = workers.object(at: indexPath.row)
                
        self.performSegue(withIdentifier: "WorkersToWorkerInfo", sender: worker)
        
        tableWorkers.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? WorkerInfoViewController {
            
            controller.worker = sender! as! NSDictionary
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func loadWorkers() {
        guard let url = URL(string: "http://0.0.0.0:1234/workers?department=\(WORKER.department)")
            else {
                self.alertError(message: "Text can't have spaces")
                return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
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
                let json = try JSONSerialization.jsonObject(with: loadData, options: [])
                    as! NSArray
                
                OperationQueue.current?.addOperation {
                    self.workers = json
                }
                
            } catch {
                print("error trying to convert data to JSON")
                return
            }
        }
        
        task.resume()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */

}

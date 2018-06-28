//
//  WorkerClass.swift
//  Worker
//
//  Created by TONY on 27/06/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import Foundation

class Worker {
    var workerId: Int
    var department: String
    var hireDate: String
    var vacationDaysHave: Int
    
    init(workerId: Int, department: String, hireDate: String, vacationDaysHave: Int) {
        self.workerId = workerId
        self.department = department
        self.hireDate = hireDate
        self.vacationDaysHave = vacationDaysHave
    }
}

var WORKER = Worker(workerId: 0, department: "", hireDate: "", vacationDaysHave: 0)

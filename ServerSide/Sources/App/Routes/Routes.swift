import Vapor
import PostgreSQL
import Node

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }
        
        get("greeting") { req in
            guard let name = req.data["target"]?.string else {
                return "Hello!"
            }
            return "Hello, \(name)!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        post("user") { req in
            guard let userName = req.data["userName"]?.string
                else { throw Abort.badRequest }
            
            let user = User(userName: userName, email: "", password: "")
            
            try user.save()
            
            return "Success!\n"
        }
        
        //MARK: My methods
        
        let PSQL = try PostgreSQL.Database(hostname: "127.0.0.1", port: 5432, database: "Tony", user: "Tony", password: "")
        let connectionPSQL = try PSQL.makeConnection()
        
        //post
        
        post("worker", "new") { req in
            guard let id_worker = req.data["id"]?.int,
                let first_name = req.data["first_name"]?.string,
                let last_name = req.data["last_name"]?.string,
                let department = req.data["department"]?.string,
                let hire_date = req.data["hire_date"]?.string,
                let vacation_days_had = req.data["vacation_days_had"]?.int
                else { throw Abort.badRequest }
            
            let _ = try connectionPSQL.execute("INSERT INTO workers VALUES ($1, $2, $3, $4, $5, $6);", [id_worker, first_name, last_name, department, hire_date, vacation_days_had])
            
            return "Success!\n"
        }
        
        
        post("request", "new") { req in
            guard let period = req.data["period"]?.string,
                let department = req.data["department"]?.string,
                let id_worker = req.data["id"]?.int,
                let date_start = req.data["date_start"]?.string,
                let date_end = req.data["date_end"]?.string
                else { throw Abort.badRequest }
            
            let _ = try connectionPSQL.execute("INSERT INTO requests (period, department, id_worker, date_start, date_end, status) VALUES ($1, $2, $3, $4, $5, $6);", [period, department, id_worker, date_start, date_end, "in work"])
            
            return "Success!\n"
        }
        
        post("timeline", "new") { req in
            guard let period = req.data["period"]?.string,
                let department = req.data["department"]?.string,
                let id_worker = req.data["id_worker"]?.int,
                let date_start = req.data["date_start"]?.string,
                let date_end = req.data["date_end"]?.string
                else { throw Abort.badRequest }
            
            let _ = try connectionPSQL.execute("INSERT INTO timeline (period, department, id_worker, date_start, date_end) VALUES ($1, $2, $3, $4, $5);",  [period, department, id_worker, date_start, date_end])
            
            return "Success!\n"
        }
        
        //get
        
        get("worker") { req in
            guard let id_worker = req.data["id"]?.int
                else { throw Abort.badRequest }
            
            let worker = try connectionPSQL.execute("SELECT * FROM workers WHERE id_worker = $1", [id_worker])
            
            return JSON(worker)
        }
        
        get("workers") { req in
            guard let department = req.data["department"]?.string
                else { throw Abort.badRequest }
            
            let workers = try connectionPSQL.execute("SELECT * FROM workers WHERE department = $1", [department])
            
            return JSON(workers)
            
        }
        
        get("request") { req in
            guard let idWorker = req.data["id"]?.int
                else { throw Abort.badRequest }
            
            let request = try connectionPSQL.execute("SELECT * FROM requests WHERE id_worker = $1", [idWorker])
            
            return JSON(request)
        }
        
        get("requests") { req in
            guard let department = req.data["department"]?.string
                else { throw Abort.badRequest }
            
            let requests = try connectionPSQL.execute("SELECT * FROM requests WHERE department = $1", [department])
            
            return JSON(requests)
        }
        
        get("timeline") { req in
            guard let period = req.data["period"]?.string
                else { throw Abort.badRequest }
            
            let timeline = try connectionPSQL.execute("SELECT * FROM timeline WHERE period = $1", [period])
            
            return JSON(timeline)
        }
        
        get("timeline", "with_department") { req in
            guard let period = req.data["period"]?.string,
                let department = req.data["dapartment"]?.string
                else { throw Abort.badRequest }
            
            let timeline = try connectionPSQL.execute("SELECT * FROM timeline WHERE period = $1 AND department = $2", [period, department])
            
            return JSON(timeline)
        }
        
        get("calculate_vacation") { req in
            guard let hireDate = req.data["hire_date"]?.string
                else { throw Abort.badRequest }
            
            let days = try connectionPSQL.execute("SELECT CURRENT_DATE - DATE '\(hireDate)'", [0])
            
            return JSON(days)
        }
        
        get("calculate_days") { req in
            guard let dateStart = req.data["date_start"]?.string,
                let dateEnd = req.data["date_end"]?.string
                else { throw Abort.badRequest }
            
            let days = try connectionPSQL.execute("SELECT DATE '\(dateStart)' - DATE '\(dateEnd)'", [0])
            
            return JSON(days)
        }
        
        //put
        
        put("worker_had_vacation") { req in
            guard let idWorker = req.data["id"]?.int,
                let days = req.data["days"]?.int
                else { throw Abort.badRequest }
            
            let _ = try connectionPSQL.execute("UPDATE workers SET vacation_days_had = vacation_days_had + \(days) WHERE id_worker = \(idWorker);", [0])
            
            return "Success!\n"
        }
        
        get("worker_had_vacation2") { req in
            guard let idWorker = req.data["id"]?.int,
                let days = req.data["days"]?.int
                else { throw Abort.badRequest }
            
            let _ = try connectionPSQL.execute("UPDATE workers SET vacation_days_had = vacation_days_had + \(days) WHERE id_worker = \(idWorker);", [0])
            
            return "Success!\n"
        }
        
        put("update_request_status") { req in
            guard let idRequest = req.data["id"]?.int,
                let status = req.data["status"]?.string
                else { throw Abort.badRequest }
            
            let _ = try connectionPSQL.execute("UPDATE requests SET status = $2 WHERE id = $1", [idRequest, status])
            
            return "Success!\n"
            
        }
        
        //delete
        
        delete("delete_worker") { req in
            guard let idWorker = req.data["id"]?.int
                else { throw Abort.badRequest }
            
            let _ = try connectionPSQL.execute("DELETE FROM workers WHERE id_worker = $1", [idWorker])
            
            return "Success!\n"
        }
        
        delete("delete_request") { req in
            guard let idRequest = req.data["id"]?.string
                else { throw Abort.badRequest }
            
             let _ = try connectionPSQL.execute("DELETE FROM requests WHERE id = $1", [idRequest])
            
            return "Success!\n"
        }
        
        try resource("posts", PostController.self)
    }
}

//
//  WaitListViewController.swift
//  pSuCsTutor
//
//  Created by Thong Tran on 8/2/17.
//  Copyright © 2017 ThongApp. All rights reserved.
//

import UIKit
import Firebase
class WaitListViewController: UIViewController {
    
    var schedules = [Schedule]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSchedule()
        // Do any additional setup after loading the view.
    }

    
    @IBOutlet var tableView: UITableView!
    
}


extension WaitListViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedules.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellWaitList", for: indexPath) as! WaitListTableViewCell
        cell.schedule = schedules[indexPath.row]
        return cell
        
    }
}



extension WaitListViewController {
    func fetchSchedule () {
            let ref = FIRDatabase.database().reference().child("Schedule")
            ref.observe(.childAdded, with: { (snapshot) in
               
                if let dictionary = snapshot.value as? [String: AnyObject] {
                        let schedule = Schedule()
                        schedule.class_name = dictionary["Class"] as? String
                        schedule.name_student = dictionary["Name "] as? String
                        schedule.name_id = dictionary["StudentID"] as? String
                    
                        let time_string = dictionary["Time"] as? String
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        let date = dateFormatter.date(from: time_string!)
                        schedule.time = date
                        self.schedules.append(schedule)
                    self.schedules.sort(by: { $0.time?.compare($1.time!) == .orderedAscending})

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
                
                
                
            }, withCancel: nil)
    }
}



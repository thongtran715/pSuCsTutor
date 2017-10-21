//
//  WaitListTableViewCell.swift
//  pSuCsTutor
//
//  Created by Thong Tran on 8/2/17.
//  Copyright © 2017 ThongApp. All rights reserved.
//

import UIKit

class WaitListTableViewCell: UITableViewCell {
    @IBOutlet var scheduleLabel: UILabel!
    @IBOutlet var classLabel: UILabel!
    @IBOutlet var nameStudent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var schedule : Schedule? {
        didSet {
        classLabel.text = schedule?.class_name
        nameStudent.text = schedule?.name_student
        let dateFormat = DateFormatter()
            dateFormat.dateFormat = "HH:mm a"
            dateFormat.amSymbol = "AM"
            dateFormat.pmSymbol = "PM"
            let time = dateFormat.string(from: (schedule?.time!)!)
            scheduleLabel.text = time
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

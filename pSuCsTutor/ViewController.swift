//
//  ViewController.swift
//  pSuCsTutor
//
//  Created by Thong Tran on 8/2/17.
//  Copyright © 2017 ThongApp. All rights reserved.
//

import UIKit
import Firebase
// Utils Struct function 
struct Utils {
    
    // Making Alert Struct function
    static func display_alert (targetVc: UIViewController, title title1: String,  message message1 : String )
    {
        let alertView = UIAlertController(title: title1, message: message1, preferredStyle: .alert)
        let ok_action = UIAlertAction(title: "Ok", style: .default) { (action) in
            
        }
        alertView.addAction(ok_action)
        targetVc.present(alertView, animated: true, completion: nil)
    }
    static func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour):\(minutes)"
    }
}

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var studentId: UITextField!
    @IBOutlet var studentNameTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
            datePicker.datePickerMode = .time
            studentId.delegate = self
            studentNameTxt.delegate = self
            self.schedule_time = Utils.currentTime()
    }
    @IBOutlet var classPickerView: UIPickerView!
    
    @IBOutlet var datePicker: UIDatePicker!

    var class_name: String = "CS 161"
    var schedule_time: String?
    var classesArray = ["CS 161", "CS 162", "CS 163", "CS 201", "CS 202", "CS 250", "CS 251", "CS 300", "CS 311", "Others"]
    
    
    @IBAction func datePickerAction(_ sender: Any) {
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let startDate = dateFormatter.string(from: datePicker.date)
            schedule_time = startDate
    }
    @IBAction func scheduleButton(_ sender: Any) {
       let name = studentNameTxt.text
        let id = studentId.text
        
        if name == "" || id == "" {
            Utils.display_alert(targetVc: self, title: "Error", message: "Please Check your Info")
                return
        }
        let values = ["Name ": name, "StudentID": id, "Class": class_name, "Time": schedule_time]
        handleSchedule(values: values as [String : AnyObject])
        Utils.display_alert(targetVc: self, title: "Successfully", message: "You have booked an appointment with us successfully. Your appointment might happen late. Please be aware")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



extension ViewController {
    func handleSchedule ( values : [String : AnyObject])  {
        let ref = FIRDatabase.database().reference(fromURL: "https://psucstutor.firebaseio.com/").child("Schedule")
        let refChild = ref.childByAutoId()
        refChild.updateChildValues(values)
    }
}









extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return classesArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return classesArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        class_name = classesArray[row] 
    }
}

//
//  CreateTaskController.swift
//  Taskly
//
//  Created by 張駿彥 on 2019/3/7.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class CreateTaskController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate  {

    var task: String = ""
    var date_text: String = ""
    
    var date = ["每天","每週","每月","每兩個月","每三個月","每四個月","每五個月","每半年","每年"]
    
    @IBOutlet weak var taskText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.white
        dateText.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        dateText.inputAccessoryView = toolBar
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveSegue" {
            task = taskText.text!
            date_text = dateText.text!
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return date.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return date[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dateText.text = date[row]
    }
    
    @objc func doneClick() {
        dateText.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        dateText.resignFirstResponder()
    }
}

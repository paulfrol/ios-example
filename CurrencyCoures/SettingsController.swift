//
//  SettingsController.swift
//  CurrencyCoures
//
//  Created by Paul Frol on 20/05/2019.
//  Copyright © 2019 Paul Frol. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func showAction(_ sender: Any) {
        Model.shared.loadXMLFile(date: datePicker.date)
//        print(datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

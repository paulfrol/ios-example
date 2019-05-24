//
//  ConvertorController.swift
//  CurrencyCoures
//
//  Created by Paul Frol on 22/05/2019.
//  Copyright © 2019 Paul Frol. All rights reserved.
//

import UIKit

class ConvertorController: UIViewController {
    

    @IBOutlet weak var labelCoures: UILabel!
    
    @IBOutlet weak var buttonFrom: UIButton!
    @IBOutlet weak var buttonTo: UIButton!
    @IBOutlet weak var textFrom: UITextField!
    @IBOutlet weak var textTo: UITextField!
    @IBAction func pushFromAction(_ sender: Any) {
        let nc = storyboard?.instantiateViewController(withIdentifier: "selectedCurrencyNSB") as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrencyViewController).flagCurrency = .from
        present(nc, animated: true, completion: nil)
    }
    @IBAction func pushToAction(_ sender: Any) {
        let nc = storyboard?.instantiateViewController(withIdentifier: "selectedCurrencyNSB") as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrencyViewController).flagCurrency = .to
        present(nc, animated: true, completion: nil)
    }
    @IBAction func textFromEditingChange(_ sender: Any) {
        let amount_ = Double(textFrom.text!)
        textTo.text = Model.shared.convert(amount: amount_)
    }
    
    func refreshButtons() {
        buttonFrom?.setTitle(Model.shared.fromCurrency.CharCode, for: UIControl.State.normal)
        buttonTo?.setTitle(Model.shared.toCurrency.CharCode, for: UIControl.State.normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFrom.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshButtons()
        textFromEditingChange(self)
        labelCoures.text = "Курсы за дату: \(Model.shared.currentDate)"
        navigationItem.rightBarButtonItem = nil
    }
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    
    @IBAction func pushDone(_ sender: Any) {
        textFrom.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
}
extension ConvertorController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationItem.rightBarButtonItem = buttonDone
        return true
    }
}

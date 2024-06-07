//
//  ViewController.swift
//  CustomeDataAPICalling
//
//  Created by Arpit iOS Dev. on 06/06/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchDataTextField: UITextField!
    @IBOutlet weak var btnDone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchDataTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        if let query = searchDataTextField.text, !query.isEmpty {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "APIShowDataViewController") as? APIShowDataViewController {
                vc.query = query
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        searchDataTextField.resignFirstResponder()
    }
}

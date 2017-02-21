//
//  SignUpScreenViewController.swift
//  PlantPal2.0
//
//  Created by Gabriel Borges on 12/7/16.
//  Copyright © 2016 Gabe Borges. All rights reserved.
//

import UIKit

class SignUpScreenViewController: UIViewController {
    
    @IBOutlet weak var FirstNameField: UITextField!
    @IBOutlet weak var LastNameField: UITextField!
    @IBOutlet weak var UserNameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var PasswordConfirmField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpScreenViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SubmitActionButton(_ sender: UIButton) {
        if (PasswordField.text! != PasswordConfirmField.text!) {
            let alertController = UIAlertController(title: "Password Mismatch", message: "The two passwords do not match!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay.", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else if (UserNameField.text!.isEmpty || PasswordField.text!.isEmpty || LastNameField.text!.isEmpty || FirstNameField.text!.isEmpty || EmailField.text!.isEmpty) {
            let alertController = UIAlertController(title: "Login Error", message: "One or more fields are not completed!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay.", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let tabBarView = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! TabBarViewController
            self.present(tabBarView, animated: true, completion: nil)
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

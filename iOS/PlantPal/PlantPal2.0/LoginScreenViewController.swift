//
//  LoginScreenViewController.swift
//  PlantPal2.0
//
//  Created by Gabriel Borges on 12/7/16.
//  Copyright © 2016 Gabe Borges. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController {
    
    @IBOutlet weak var UserNameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginScreenViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SubmitActionButton(_ sender: UIButton) {
        if (UserNameField.text!.isEmpty || PasswordField.text!.isEmpty) {
            let alertController = UIAlertController(title: "Login Error", message: "Missing Username or Passowrd!", preferredStyle: .alert)
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

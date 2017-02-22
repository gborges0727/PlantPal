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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(SignUpScreenViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SubmitActionButton(_ sender: UIButton) {
        //First, check if the two passwords are equal
        if (PasswordField.text! != PasswordConfirmField.text!) {
            let alertController = UIAlertController(title: "Password Mismatch",
                message: "The two passwords do not match!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay.", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        
        // Next check whether any of the required fields are empty
        else if (UserNameField.text!.isEmpty || PasswordField.text!.isEmpty ||
            LastNameField.text!.isEmpty || FirstNameField.text!.isEmpty || EmailField.text!.isEmpty) {
            let alertController = UIAlertController(title: "Login Error",
                message: "One or more fields are not completed!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay.", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        
        // Creates JSON from user input and sends request
        else {
            // Create alert controller here to say something along the lines of "Signing Up..."
            let infoDictionary = [
                "firstName": FirstNameField.text!,
                "lastName":  LastNameField.text!,
                "userName":  UserNameField.text!,
                "passWord":  PasswordField.text!,
                "email":     EmailField.text!
            ]
            
            // Whole block = send above dictionary as JSON to server:
            if JSONSerialization.isValidJSONObject(infoDictionary) {
                do {
                    let jsonObject = try JSONSerialization.data(withJSONObject: infoDictionary,
                        options: .prettyPrinted)
                    
                    // Create Post request
                    let url = URL(string: "https://plantpal.uconn.edu/login:5050") // IS POSSIBLE TO CHANGE! :D
                    var request = URLRequest(url: url!)
                    request.httpMethod = "POST"
                    
                    // Append JSON object
                    request.httpBody = jsonObject
                    
                    // Send request
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil else {
                            print(error?.localizedDescription ?? "No Data")
                            return
                        }
                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let responseJSON = responseJSON as? [String: Any] {
                            print(responseJSON)
                        }
                    }
                    task.resume() // Sends the request
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            // Send to next view (IFF the above works)
            let tabBarView = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                as! TabBarViewController
            self.present(tabBarView, animated: true, completion: nil)
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

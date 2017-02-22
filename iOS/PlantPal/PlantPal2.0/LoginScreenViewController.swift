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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(LoginScreenViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SubmitActionButton(_ sender: UIButton) {
        // Checks for missing fields
        if (UserNameField.text!.isEmpty || PasswordField.text!.isEmpty) {
            let alertController = UIAlertController(title: "Login Error",
                message: "Missing Username or Passowrd!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay.", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        
        else {
            let infoDictionary = [
                "name": UserNameField.text!,
                "password": PasswordField.text!
            ]
            
            // TODO: Send this http request
            if JSONSerialization.isValidJSONObject(infoDictionary) {
                do {
                    let jsonObject = try JSONSerialization.data(withJSONObject: infoDictionary,
                        options: .prettyPrinted)
                    
                    // Create Post request
                    let url = URL(string: "https://plantpal.uconn.edu/signup:5050") // IS POSSIBLE TO CHANGE! :D
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
            // Run the below only if http 201 is returned (authenticated)
            let tabBarView = self.storyboard?.instantiateViewController(
                withIdentifier: "TabBar") as! TabBarViewController
            self.present(tabBarView, animated: true, completion: nil)
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

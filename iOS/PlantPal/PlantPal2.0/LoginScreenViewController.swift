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
    
    static var username = ""
    
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
    @IBAction func BackActionButton(_ sender: UIButton) {
        let firstView = self.storyboard?.instantiateViewController(withIdentifier: "FirstScreen") as! FirstScreenViewController
        self.present(firstView, animated: true, completion: nil)
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
            LoginScreenViewController.username = UserNameField.text!
            let infoDictionary = [
                "username": UserNameField.text!,
                "password": PasswordField.text!
            ]
            
            // TODO: Send this http request
            if JSONSerialization.isValidJSONObject(infoDictionary) {
                do {
                    let jsonObject = try JSONSerialization.data(withJSONObject: infoDictionary,
                        options: .prettyPrinted)
                    
                    // Create Post request
                    let url = URL(string: "https://plantpal.uconn.edu:4607/users/login")
                    var request = URLRequest(url: url!)
                    request.httpMethod = "POST"
                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

                    
                    // Append JSON object
                    request.httpBody = jsonObject
                    
                    // Send request
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil else {
                            print(error?.localizedDescription ?? "No Data")
                            let alertController = UIAlertController(title: "ERROR: Could not connect to the server", message:
                                "Please make sure you are connected to UConn-Secure", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                            
                            self.present(alertController, animated: true, completion: nil)
                            return
                        }
                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        let httpResponse = response as! HTTPURLResponse
                        let statusCode = httpResponse.statusCode
                        let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        if let responseJSON = responseJSON as? [String: Any] {
                            print(responseJSON)
                        }
                        if (statusCode == 200) {
                            // Add code here to preserve username info: Needed when picture is uploaded
                            let tabBarView = self.storyboard?.instantiateViewController(
                                withIdentifier: "TabBar") as! TabBarViewController
                            self.present(tabBarView, animated: true, completion: nil)
                        }
                        else if (statusCode == 404) {
                            let alertController = UIAlertController(title: "Incorrect Username!",
                                                                    message: responseString as String?, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        } else if (statusCode == 401) {
                            let alertController = UIAlertController(title: "Incorrect Password!",
                                                                    message: responseString as String?, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            let alertController = UIAlertController(title: "Error",
                                                                    message: "Unknown Error occured! Please try again.", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    task.resume() // Sends the request
                } catch {
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

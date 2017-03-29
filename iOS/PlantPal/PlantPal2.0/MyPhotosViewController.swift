//
//  SecondViewController.swift
//  PlantPal2.0
//
//  Created by Gabriel Borges on 11/29/16.
//  Copyright © 2016 Gabe Borges. All rights reserved.
//

import UIKit

class MyPhotosViewController: UIViewController {
    
    // username should be preserved across viewcontrollers: Hard coded for now :)
    let username = "plants123"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Below code retrieves all plant pictures for the user w/ given username
        let infoDictionary = [
            "username": username
        ]
        
        // TODO: Send this http request
        if JSONSerialization.isValidJSONObject(infoDictionary) {
            do {
                let jsonObject = try JSONSerialization.data(withJSONObject: infoDictionary,
                                                            options: .prettyPrinted)
                
                // Create Post request
                let url = URL(string: "https://plantpal.uconn.edu:4607/myPlants/allPlants")
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                
                
                // Append JSON object
                request.httpBody = jsonObject
                
                // Send request
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No Data")
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
                        // Add code here to display the pictures from the response: Remember, response will be
                        // A JSON array with URLS to images :)
                    }
                    else if (statusCode == 404) {
                        let alertController = UIAlertController(title: "Connection Error!",
                                                                message: "Unable to retrieve your plant pictures. Please retry in a few minutes!" as String?, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "Error",
                                                                message: "Unknown Error Occured!", preferredStyle: .alert)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//  SecondViewController.swift
//  PlantPal2.0
//
//  Created by Gabriel Borges on 11/29/16.
//  Copyright © 2016 Gabe Borges. All rights reserved.
//

import UIKit

class MyPhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // username should be preserved across viewcontrollers: Hard coded for now :)
    let username = LoginScreenViewController.username
    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    
    // To add to plantInfo, DO: plantInfo.append((location: "localString", plantType: "plantTypeString"))
    var plantInfo:[(location: String, plantType: String)] = []
    
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var plantList: UITableView!
    
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
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    if (statusCode == 200) {
                        // Add code here to display the pictures from the response: Remember, response will be
                        // A JSON array with URLS to images :)
                        print("test")
                        do {
                            if let data = data,
                                let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let pictures = jsonResponse["pictures"] as? [[String: Any]] {
                                for picture in pictures {
                                    if let location = picture["location"] as? String,
                                        let value = picture["plantType"] as? String {
                                        self.plantInfo.append((location: location, plantType: value))
                                    }
                                }
                            }
                            self.plantList.reloadData()
                        } catch {
                            print("Error deserializing JSON: \(error)")
                        }
                        print(self.plantInfo)
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
        
        self.plantList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        plantList.delegate = self
        plantList.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("run")
        print(self.plantInfo.count)
        return self.plantInfo.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.plantList.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        print(plantInfo)
        print("plantinfo printed above (from within func tableView")
        cell.textLabel?.text = self.plantInfo[indexPath.row].plantType
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


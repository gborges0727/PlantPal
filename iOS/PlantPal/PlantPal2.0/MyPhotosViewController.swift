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
    
    // To add to plantInfo, DO: plantInfo.append((location: "localString", plantType: "plantTypeString"))
    var plantInfo:[(location: String, plantType: String, percentage: String, secondClosest: String, secondClosestPercent: String)] = []
    
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var plantList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePlants()
        
        plantList.delegate = self
        plantList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(plantInfo)
        updatePlants()
        self.plantList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("run")
        //print(self.plantInfo.count)
        return self.plantInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // set the text from the data model
        let cell:MyCustomCellModel = self.plantList.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MyCustomCellModel
        //print(self.plantInfo[indexPath.row].location)
        if let url  = NSURL(string: "https://plantpal.uconn.edu:4607/dispImages" + self.plantInfo[indexPath.row].location),
            let data = NSData(contentsOf: url as URL)
        {
            //print("this was reached")
            cell.plantImage.image = UIImage(data: data as Data)
        }
        
        cell.plantLabel.text = self.plantInfo[indexPath.row].plantType.lowercased().capitalized + " " + self.plantInfo[indexPath.row].percentage.lowercased().capitalized + "%"
        cell.secondClosestLabel.text = self.plantInfo[indexPath.row].secondClosest.lowercased().capitalized + " " + self.plantInfo[indexPath.row].secondClosestPercent.lowercased().capitalized + "%"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You tapped cell number \(indexPath.row).")
        let specificPlantView = self.storyboard?.instantiateViewController(
            withIdentifier: "specificPlant") as! SpecificPlantViewController
        specificPlantView.plantInfo = self.plantInfo[indexPath.row]
        self.present(specificPlantView, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0; // Sets custom row height
    }
    
    func updatePlants() {
        let infoDictionary = [
            "username": username
        ]
        
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
                                print(jsonResponse)
                                self.plantInfo.removeAll()
                                for picture in pictures {
                                    if let location = picture["location"] as? String,
                                        let value = picture["plantType"] as? String,
                                        let percentage = picture["percentage"] as? String,
                                        let secondClosest = picture["secondClosest"] as? String,
                                        let secondClosestPercent = picture["secondClosestPercent"] as? String {
                                        print("AAAAAAAAAAAAAAAAAAAAAAAAA")
                                        self.plantInfo.append((location: location, plantType: value, percentage: percentage, secondClosest: secondClosest, secondClosestPercent: secondClosestPercent))
                                    }
                                }
                                self.plantInfo.reverse()
                            }
                            DispatchQueue.main.async(execute: {
                                self.plantList.reloadData()
                            })
                        } catch {
                            print("Error deserializing JSON: \(error)")
                        }
                        //print(self.plantInfo)
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


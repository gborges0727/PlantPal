//
//  SpecificPlantViewController.swift
//  PlantPal2.0
//
//  Created by Gabriel Borges on 4/11/17.
//  Copyright © 2017 Gabe Borges. All rights reserved.
//

import UIKit

class SpecificPlantViewController: UIViewController {
    
    var plantInfo:[(location: String, plantType: String)] = []
    var plantName = ""
    var sciName = ""
    var family = ""
    var nativeRegion = ""
    var plantDescrip = ""
    
    @IBAction func backToAllPlants(_ sender: UIButton) {
        let tabBarView = self.storyboard?.instantiateViewController(
            withIdentifier: "TabBar") as! TabBarViewController
        self.present(tabBarView, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlantInfo()
        print("INFO: " + plantName + " " + sciName + " " + family + " " + nativeRegion + " " + plantDescrip)
    }
    
    func getPlantInfo() {
        let infoDictionary = [
            "flowerName": "testFlower"
        ]
        if JSONSerialization.isValidJSONObject(infoDictionary) {
            do {
                let jsonObject = try JSONSerialization.data(withJSONObject: infoDictionary,
                                                            options: .prettyPrinted)
                
                // Create Post request
                let url = URL(string: "https://plantpal.uconn.edu:4607/myPlants/specificPlant")
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
                        do {
                            if let data = data,
                                let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                                for item in jsonResponse {
                                    print(item)
                                }
                                if let name = jsonResponse["name"] as? String,
                                    let sci = jsonResponse["sciName"] as? String,
                                    let fam = jsonResponse["family"] as? String,
                                    let region = jsonResponse["nativeRegion"] as? String,
                                    let descrip = jsonResponse["Description"] as? String {
                                    print("Hit here")
                                    self.plantName = name
                                    self.sciName = sci
                                    self.family = fam
                                    self.nativeRegion = region
                                    self.plantDescrip = descrip
                                }
                            }
                            print("INFO: " + self.plantName + " " + self.sciName + " " + self.family + " " + self.nativeRegion + " " + self.plantDescrip)
                        } catch {
                            print("Error deserializing JSON: \(error)")
                        }
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
}

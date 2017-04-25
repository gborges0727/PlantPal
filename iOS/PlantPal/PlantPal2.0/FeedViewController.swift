//
//  FirstViewController.swift
//  PlantPal2.0
//
//  Created by Gabriel Borges on 11/29/16.
//  Copyright © 2016 Gabe Borges. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // plantInfo stores the 10 most recently uploaded pictures that are on the server
    var plantInfo:[String] = []
    let cellReuseIdentifier = "cell2"
    var plantNameAndUsername:[(String, String)] = [] // First string in tuple is name, second is username
    
    @IBOutlet weak var plantList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getFeedList()
        getNameAndUsername()
        print(plantNameAndUsername)
        plantList.allowsSelection = false
        plantList.delegate = self
        plantList.dataSource = self
        plantList.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFeedList()
        getNameAndUsername()
        print(plantNameAndUsername)
        self.plantList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.plantInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // set the text from the data model
        let cell:MySecondCustomCellModel = self.plantList.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MySecondCustomCellModel
        if let url  = NSURL(string: "https://plantpal.uconn.edu:4607/dispImages" + "/var/www/plantpal.uconn.edu/ProjectFiles/Backend/node-express-gen/userImages/" + self.plantInfo[indexPath.row]),
            let data = NSData(contentsOf: url as URL)
        {
            cell.plantPictureView.image = UIImage(data: data as Data)
        }
        
        cell.flowerNameLabel.text = plantNameAndUsername[indexPath.row].0
        cell.userNameLabel.text = plantNameAndUsername[indexPath.row].1
        
        // TODO: Fill out remainder of plant info cell here once it is realized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Input functionality to move to specific view controller.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0; // Sets custom row height
    }
    
    func getNameAndUsername() {
        let semaphore = DispatchSemaphore(value: 0)
        self.plantNameAndUsername.removeAll()
        for plant in plantInfo {
            do {
                let url = URL(string: "https://plantpal.uconn.edu:4607/feed/getPlantInfo")
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                
                // add plant name to body request
                let infoDictionary = [
                    "fileName": plant
                ]
                let jsonObject = try JSONSerialization.data(withJSONObject: infoDictionary,
                                                            options: .prettyPrinted)
                request.httpBody = jsonObject
                
                // Send request
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    if (statusCode == 200) {
                        do {
                            if let data = data,
                                let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                                if let plantName = jsonResponse["plantName"] as? String,
                                    let uploader = jsonResponse["uploader"] as? String {
                                    self.plantNameAndUsername.append((plantName.lowercased().capitalized, uploader))
                                }
                            }
                        } catch {
                            print("Error deserializing JSON: \(error)")
                        }
                    }
                    else if (statusCode == 404) {
                        let alertController = UIAlertController(title: "Connection Error!",
                                                                message: "Unable to retrieve your plant info. Please retry in a few minutes!" as String?, preferredStyle: .alert)
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
                    semaphore.signal()
                }
                task.resume()
                semaphore.wait(timeout: .distantFuture)
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func getFeedList() {
        do {            
            // Create Post request
            let url = URL(string: "https://plantpal.uconn.edu:4607/feed")
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            // Send request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if (statusCode == 200) {
                    do {
                        if let data = data,
                            let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            self.plantInfo.removeAll()
                            if let locations = jsonResponse["pictures"] as? String {
                                self.plantInfo = locations.lines
                                self.plantInfo.reverse()
                            }
                        }
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
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
        print(self.plantNameAndUsername)
    }
}

// Used to parse server response in getFeedList()
extension String {
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}


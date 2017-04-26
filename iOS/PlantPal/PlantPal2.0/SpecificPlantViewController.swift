//
//  SpecificPlantViewController.swift
//  PlantPal2.0
//
//  Created by Gabriel Borges on 4/11/17.
//  Copyright © 2017 Gabe Borges. All rights reserved.
//

import UIKit
import QuartzCore

class SpecificPlantViewController: UIViewController {
    
    @IBOutlet weak var plantNameLabel: UILabel!
    //@IBOutlet weak var plantDescripLabel: UITextView!
    @IBOutlet weak var plantDescripLabel: UITextView!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantSciName: UILabel!
    @IBOutlet weak var plantFamily: UILabel!
    
    
    
    var plantInfo = ("", "", "", "", "") // First string is location, second is type, third is percent, fourth is secondclosest, fifth is secondclosestpercent
    var plantName = ""
    var sciName = ""
    var family = ""
    var nativeRegion = ""
    var plantDescrip = ""
    var test = "hello"
    var p = ""
    var newP = ""


    @IBAction func wrongMatchActionButton(_ sender: UIButton) {
        newP = self.plantInfo.3.lowercased().capitalized
        let alertController = UIAlertController(title: "We appreciate your feedback!", message:
            "It will help with our ongoing algorithm development", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Try Second Match", style: UIAlertActionStyle.default,handler: {(action:UIAlertAction!) in self.getPlantInfo(p: self.newP);
            print(self.newP);
            self.plantDescripLabel.text? = "Plant Name: " + self.plantName + "\n\n";
            self.plantDescripLabel.text? += "Scientific Name: " + self.sciName + "\n\n";
            self.plantDescripLabel.text? +=  "Family Name: " + self.family + "\n\n";
            self.plantDescripLabel.text? += "Description: " + self.plantDescrip + "\n\n";
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backToAllPlants(_ sender: UIButton) {
        let tabBarView = self.storyboard?.instantiateViewController(
            withIdentifier: "TabBar") as! TabBarViewController
        self.present(tabBarView, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        p = self.plantInfo.1.lowercased().capitalized
        getPlantInfo(p: p)
        
        // Testing Bold Fonts
        let att = [NSFontAttributeName: UIFont.fontNames(forFamilyName: "Futura Medium")]
        let sciBold = NSMutableAttributedString(string: "Scientific Name: ", attributes:att)
        let famBold = NSMutableAttributedString(string: "Family Name: ", attributes: att)
        let nameBold = NSMutableAttributedString(string: "Plant Name: ", attributes: att)
        let desBold = NSMutableAttributedString(string: "Description: ", attributes: att)


        
        print("INFO: " + plantName + " " + sciName + " " + family + " " + nativeRegion + " " + plantDescrip)
        if let url  = NSURL(string: "https://plantpal.uconn.edu:4607/dispImages" + self.plantInfo.0),
            let data = NSData(contentsOf: url as URL)
        {
            print("this was reached")
            self.plantImageView.layer.borderColor = UIColor.white.cgColor
            self.plantImageView.layer.borderWidth = 4
            self.plantImageView.image = UIImage(data: data as Data)
            self.plantDescripLabel.layer.borderColor = UIColor.black.cgColor
            self.plantDescripLabel.layer.borderWidth = 1
        }
        print(plantName)
        print(plantDescrip)
        if (plantName == ""){
            plantDescripLabel.text? = nameBold.string + "Not a flower\n\n"
            plantDescripLabel.text? += sciBold.string + "N/A\n\n"
            plantDescripLabel.text? += famBold.string + "N/A\n\n"
            plantDescripLabel.text? += desBold.string + "N/A\n\n"
        }
        else{
            plantDescripLabel.text? = nameBold.string + plantName + "\n\n"
            plantDescripLabel.text? += sciBold.string + sciName + "\n\n"
            plantDescripLabel.text? += famBold.string + family + "\n\n"
            plantDescripLabel.text? += desBold.string + plantDescrip + "\n\n"
        }
        
    }
    
    func getPlantInfo(p :String) {
        let plantName = p
        let infoDictionary = [
            "flowerName": plantName
        ]
        print("================================")
        print(infoDictionary)
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
                                    print("************************************")
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

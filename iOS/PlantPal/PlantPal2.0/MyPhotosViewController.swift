//
//  SecondViewController.swift
//  PlantPal2.0
//
//  Created by Gabriel Borges on 11/29/16.
//  Copyright © 2016 Gabe Borges. All rights reserved.
//

import UIKit

class MyPhotosViewController: UIViewController {
    
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var ResultsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // getImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func InvisButton(_ sender: UIButton) {
        ResultsLabel.text = "Match to flower not found!"
    }
    
    @IBAction func GetResultsButton(_ sender: UIButton) {
        ResultsLabel.text = "You have a flower!"
    }
    
    func getUserInfo() {
        var request = URLRequest(url: URL(string: "http://plantpal.uconn.edu:5050/upload/OS161.JPG")!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("error = \(error)")
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            
            // Converting Server's JSON response
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    // Print out Dictionary
                    print("The Dictionary contains \(convertedJsonIntoDict.count) items")
                    
                    // Get Value by Key
                    let firstNameValue = convertedJsonIntoDict["username"] as? String
                    print(firstNameValue ?? "Test")
                }
            } catch let error as NSError {
                print("Couldn't convert")
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getImage() {
        if let url = NSURL(string: "http://plantpal.uconn.edu:5050/upload/OS161.JPG") {
            if let data = NSData(contentsOf: url as URL) {
                self.displayImage.image = UIImage(data: data as Data)
            }
        }
    }
}


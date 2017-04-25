//
//  FifthViewController.swift
//  PlantPal2.0
//
//  Created by Gabriel Borges on 11/29/16.
//  Copyright © 2016 Gabe Borges. All rights reserved.
//

import UIKit
import SafariServices

class StoreViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openStoreActionButton(_ sender: UIButton) {
        let url = URL(string: "https://web9.uits.uconn.edu/uconnblooms/")
        
        // Do any additional setup after loading the view, typically from a nib.
        let svc = SFSafariViewController(url: url!)
        present(svc, animated: true, completion: nil)
    }
    
}

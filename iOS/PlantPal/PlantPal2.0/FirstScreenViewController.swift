//
//  FourthViewController.swift
//  PlantPal2.0
//
//  Created by Gabriel Borges on 11/29/16.
//  Copyright © 2016 Gabe Borges. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginActionButoon(_ sender: UIButton) {
        let loginView = self.storyboard?.instantiateViewController(withIdentifier: "LogIn Screen") as! LoginScreenViewController
        self.present(loginView, animated: true, completion: nil)
    }
    
    @IBAction func SignUpActionButton(_ sender: UIButton) {
        let signUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUp Screen") as! SignUpScreenViewController
        self.present(signUpView, animated: true, completion: nil)
    }
    
}

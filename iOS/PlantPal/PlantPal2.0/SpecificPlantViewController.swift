//
//  SpecificPlantViewController.swift
//  PlantPal2.0
//
//  Created by Gabriel Borges on 4/11/17.
//  Copyright © 2017 Gabe Borges. All rights reserved.
//

import UIKit

class SpecificPlantViewController: UIViewController {
    
    @IBAction func backToAllPlants(_ sender: UIButton) {
        let tabBarView = self.storyboard?.instantiateViewController(
            withIdentifier: "TabBar") as! TabBarViewController
        self.present(tabBarView, animated: true, completion: nil)
    }
}

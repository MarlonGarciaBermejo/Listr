//
//  ViewController.swift
//  Listr
//
//  Created by Marlon Garcia-Bermejo on 2023-04-17.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var enterVC: UIButton!
    let db = Firestore.firestore()
    let segueIdEnter = "enterSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        func enterButton(_ sender: UIButton) {
            performSegue(withIdentifier: segueIdEnter, sender: self)
        }
            
        
       
        
      
    }


}


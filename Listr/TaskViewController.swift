//
//  TaskViewController.swift
//  Listr
//
//  Created by Marlon Garcia-Bermejo on 2023-04-20.
//

import UIKit

class TaskViewController: UIViewController, UITextFieldDelegate {
   @IBOutlet var label: UILabel!    
    var task: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        label.text = task
    
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTask))
    
}
 @objc func deleteTask() {
     
   //  let newCount = count - 1
        
   //  UserDefaults().setValue(newCount, forKey: "count")
   //  UserDefaults().setValue(nil, forKey: "task_\(currentPosition)")
     
    }

}

    



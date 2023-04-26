//
//  TaskViewController.swift
//  Listr
//
//  Created by Marlon Garcia-Bermejo on 2023-04-20.
//

import UIKit
import Firebase

class TaskViewController: UIViewController, UITextFieldDelegate {
   
 
    @IBOutlet weak var field: UITextField!
    
    var update: (() -> Void)?
    var task: String?
    var currentPosition: Int = 0
    var documentID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        field.delegate = self
        
        field.text = task
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
        
    }
        
        
    @objc func saveTask() {
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        let db = Firestore.firestore()
        let tasksRef = db.collection("habbits")
        
        // Check if the document exists
        tasksRef.document(task ?? "").getDocument { (document, error) in
            if let document = document, document.exists {
                // Document exists, update it
                tasksRef.document(self.task ?? "").updateData(["habbit": text]) { error in
                    if let error = error {
                        print("Error updating task: \(error)")
                    } else {
                        print("Task updated successfully!")
                    }
                }
            } else {
                // Document does not exist, create it
                tasksRef.document(text).setData(["habbit": text]) { error in
                    if let error = error {
                        print("Error adding task: \(error)")
                    } else {
                        print("Task added successfully!")
                    }
                }
            }
        }
        
        update?()
        navigationController?.popViewController(animated: true)
    }
}
        




    



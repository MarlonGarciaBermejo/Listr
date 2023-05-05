//
//  EntryViewController.swift
//  Listr
//
//  Created by Marlon Garcia-Bermejo on 2023-04-20.
//

import UIKit
import Firebase

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        saveTask()
        
        return true
    }

    @objc func saveTask() {
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        let db = Firestore.firestore()
        let tasksRef = db.collection("habbits")
        
        let habbitUID = UUID().uuidString
        
        tasksRef.addDocument(data: ["habbit": text]) { error in
            if let error = error {
                print("Error adding task: \(error)")
            } else {
                print("Task added successfully!")
            }
        }
        
        update?()
        navigationController?.popViewController(animated: true)
    }

}

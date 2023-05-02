//
//  ListViewController.swift
//  Listr
//
//  Created by Marlon Garcia-Bermejo on 2023-04-19.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewList: UITableView!
    
    
    let db = Firestore.firestore()
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Habbit tracker"
        
        tableViewList.delegate = self
        tableViewList.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTasks()
    }
    
    func updateTasks() {
        
        tasks.removeAll()
        
        db.collection("habbits").getDocuments { (snapshot, error) in
            let db = Firestore.firestore()
            let tasksRef = db.collection("habbits")
            
            tasksRef.getDocuments() { querySnapshot, error in
                if let error = error {
                    print("Error getting tasks: \(error)")
                } else {
                    self.tasks = querySnapshot?.documents.compactMap {
                        $0.data()["habbit"] as? String
                    } ?? []
                    
                    self.tableViewList.reloadData()
                }
            }
        }
    }
    
    @IBAction func addButton() {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry")as! EntryViewController
        vc.title = "New Habbit"
        vc.update = {
            print("Tasks: \(self.tasks)")
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "task")as! TaskViewController
        vc.title = "Habbit"
        vc.task = tasks[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        print("Task for row \(indexPath.row): \(tasks)")
        
        if tasks.isEmpty {
            cell.textLabel?.text = "No tasks"
        } else {
            cell.textLabel?.text = tasks[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            
            // delete task function
            
            let db = Firestore.firestore()
            let tasksRef = db.collection("habbits")
            
            tasksRef.whereField("habbit", isEqualTo: task).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                } else {
                    guard let documents = snapshot?.documents else { return }
                    
                    for document in documents {
                        tasksRef.document(document.documentID).delete() { error in
                            if let error = error {
                                print("Error deleting document: \(error)")
                            } else {
                                print("Document successfully deleted!")
                            }
                        }
                    }
                }
            }
            
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


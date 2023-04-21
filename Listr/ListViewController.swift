//
//  ListViewController.swift
//  Listr
//
//  Created by Marlon Garcia-Bermejo on 2023-04-19.
//

import UIKit
import Firebase

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableViewList: UITableView!
    
    let db = Firestore.firestore()
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tasks"
        
        tableViewList.delegate = self
        tableViewList.dataSource = self
        
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
            
        }
        updateTasks()
        
    }
    
        func updateTasks() {
            
            tasks.removeAll()
            
            guard let count = UserDefaults().value(forKey: "count") as? Int else {
                return
            }
            for x in 0..<count {
                if let task = UserDefaults().value(forKey: "task_\(x+1)") as? String {
                    tasks.append(task)
                }
        }
            tableViewList.reloadData()
    }
    
    @IBAction func addButton() {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry")as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
    
    extension ListViewController: UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "task")as! TaskViewController
            vc.title = "New Task"
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }

    
    extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = tasks[indexPath.row]
            
            return cell
        }
    }


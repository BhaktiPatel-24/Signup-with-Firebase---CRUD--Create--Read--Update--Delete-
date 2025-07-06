//
//  HomeVC.swift
//  Signupfirebase
//
//  Created by Apple on 05/07/25.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var text1: UITextField!
    
    var tasks: [String] = []
    var keys: [String] = [] 
    let databaseRef = Database.database(url: "https://signup-babba-default-rtdb.firebaseio.com/").reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchTasks()
    }
    
    @IBAction func add(_ sender: Any) {
        guard let task = text1.text, !task.isEmpty else { return }
        
        let taskRef = databaseRef.child("tasks").childByAutoId()
        taskRef.setValue(["title": task])
        
        text1.text = ""
    }
    
    func fetchTasks() {
        databaseRef.child("tasks").observe(.value) { snapshot in
            self.tasks.removeAll()
            self.keys.removeAll()
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any],
                   let title = value["title"] as? String {
                    
                    self.tasks.append(title)
                    self.keys.append(snap.key)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let key = keys[indexPath.row]
            databaseRef.child("tasks").child(key).removeValue()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oldTask = tasks[indexPath.row]
        let alert = UIAlertController(title: "Edit Task", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.text = oldTask }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
            if let updatedText = alert.textFields?.first?.text, !updatedText.isEmpty {
                let key = self.keys[indexPath.row]
                self.databaseRef.child("tasks").child(key).setValue(["title": updatedText])
            }
        }))
        
        present(alert, animated: true)
    }
    
    
    @IBAction func deleac(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Account",
                                      message: "Are you sure you want to delete your account?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            if let user = Auth.auth().currentUser {
                user.delete { error in
                    if let error = error {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let loginVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                            let nav = UINavigationController(rootViewController: loginVC)
                            nav.modalPresentationStyle = .fullScreen
                            self.present(nav, animated: true)
                        }
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

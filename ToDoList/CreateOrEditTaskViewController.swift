//
//  CreateOrEditTaskViewController.swift
//  ToDoList
//
//  Created by Rahul Gupta on 16/07/17.
//  Copyright © 2017 SRS. All rights reserved.
//

import UIKit
import RealmSwift

enum OperationType {
    case Create
    case Edit
}

class CreateOrEditTaskViewController: UITableViewController
{

    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskPriority: UISegmentedControl!
    @IBOutlet weak var createButton: UIButton!
    var operationType: OperationType = .Create
    var taskItem: Task?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.operationType == .Create {
            createButton.setTitle("Create Task",for: .normal)
        } else {
            self.title = "Edit Task"
            self.taskTitle.text = taskItem?.title
            self.taskPriority.selectedSegmentIndex = (taskItem?.priority)!
            createButton.setTitle("Save Task",for: .normal)
        }
        taskTitle.becomeFirstResponder()
    }
    
    @IBAction func createTask(sender: AnyObject) {
        
        if self.isDatavalid() {
            if operationType == .Create {
                let realm = try! Realm()
                let task = Task(title: taskTitle.text!, priority: taskPriority.selectedSegmentIndex)
                try! realm.write {
                    realm.add(task)
                }
            } else {
                if let realm = try? Realm(),
                    let task = realm.object(ofType: Task.self, forPrimaryKey: taskItem?.taskId as AnyObject) {
                    try! realm.write {
                        task.title = taskTitle.text!
                        task.priority = taskPriority.selectedSegmentIndex
                    }
                }
            }
            navigationController!.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "Task name is mandatory", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func isDatavalid() -> Bool {
        if let title = taskTitle.text, title != "" {
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CreateOrEditTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

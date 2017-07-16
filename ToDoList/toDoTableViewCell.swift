//
//  toDoTableViewCell.swift
//  ToDoList
//
//  Created by Rahul Gupta on 16/07/17.
//  Copyright © 2017 SRS. All rights reserved.
//

import UIKit
import RealmSwift

class toDoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taskCompletedButton: UIButton!
    @IBOutlet weak var taskPriority: UILabel!
    @IBOutlet weak var check: UIButton!
    
    var taskId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func toggleImageChecked(sender: UIButton) {
        updateTask(checked: !check.isSelected)
    }
    
    private func updateTask(checked: Bool) {
        if let realm = try? Realm(),
            let id = self.taskId,
            let task = realm.object(ofType: Task.self, forPrimaryKey: id as AnyObject) {
            
            try! realm.write {
                task.done = checked
            }
            check.isSelected = task.done
        }
    }

    
    func initWithTask(task: Task) {
        taskId = task.taskId
        check.isSelected = task.done
        titleLabel!.text = task.title
        taskPriority!.text = task.priorityText
        taskPriority!.textColor = task.priorityColor
    }

}

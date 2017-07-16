//
//  Task.swift
//  ToDoList
//
//  Created by Rahul Gupta on 16/07/17.
//  Copyright © 2017 SRS. All rights reserved.
//

import Foundation
import RealmSwift


class Task: Object {
    dynamic var taskId = NSUUID().uuidString
    dynamic var title = ""
    dynamic var done = false
    dynamic var created = NSDate()
    dynamic var priority = 0
    
    override class func primaryKey() -> String {
        return "taskId"
    }
    
    override class func indexedProperties() -> [String] {
        return ["taskId","title","done"]
    }
    
    convenience init(title: String, priority: Int) {
        self.init()
        self.title = title
        self.priority = priority
    }
}

extension Task {
    var priorityText: String {
        return priority > 0 ? "High" : "Default"
    }
    
    var priorityColor: UIColor {
        return priority > 0 ? UIColor.red : UIColor.blue
    }
}
    


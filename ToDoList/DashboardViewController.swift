//
//  DashboardViewController.swift
//  ToDoList
//
//  Created by Rahul Gupta on 16/07/17.
//  Copyright © 2017 SRS. All rights reserved.
//

import UIKit
import RealmSwift

class DashboardViewController: UIViewController {
    @IBOutlet weak var toDoTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var noDataErrorLabel: UILabel?
    var isSearchEnabled: Bool = false
    var tasks: Results<Task>!
    var searchResultArray: Results<Task>?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        
        let realm = try! Realm()
        tasks = realm.objects(Task.self)
        
    }
    
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = ToDoListHelper.barItemWithImage(image: UIImage(named: "add_icon")!, highlightedImage: UIImage(named: "add_icon")!, forFrame: CGRect.init(x: 0, y: 0, width: 25, height: 25), withPadding: 5, isLeftBarButton: false, target: self, action: #selector(didTapOnAddButton))
        self.navigationItem.leftBarButtonItem = ToDoListHelper.barItemWithImage(image: UIImage(named: "sort_icon")!, highlightedImage: UIImage(named: "sort_icon")!, forFrame: CGRect.init(x: 0, y: 0, width: 25, height: 25), withPadding: 5, isLeftBarButton: true, target: self, action: #selector(didTapOnSortButton))
    }

    func didTapOnAddButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createTaskVC = storyboard.instantiateViewController(withIdentifier: "CreateOrEditTaskViewController") as! CreateOrEditTaskViewController
        self.navigationController?.pushViewController(createTaskVC, animated: true)
    }
    
    func didTapOnSortButton() {
        
        let alertController = UIAlertController(title: "Sort By", message: "Name, Priority or Creation Date, whichever way you want to sort your todos.", preferredStyle: .alert)
        
        let nameAction = UIAlertAction(title: "Name", style: .default) { (_) in
            if self.isSearchEnabled {
                self.searchResultArray = self.searchResultArray?.sorted(byKeyPath: "title", ascending: true)
            } else {
                self.tasks = self.tasks.sorted(byKeyPath: "title", ascending: true)
            }
            self.reloadTableView(withAnimation: true)
        }
        
        let priorityAction = UIAlertAction(title: "Priority", style: .default) { (_) in
            if self.isSearchEnabled {
                self.searchResultArray = self.searchResultArray?.sorted(byKeyPath: "priority", ascending: false)
            } else {
                self.tasks = self.tasks.sorted(byKeyPath: "priority", ascending: false)
            }
            self.reloadTableView(withAnimation: true)
        }
        
        let creationDateAction = UIAlertAction(title: "Creation Date", style: .default) { (_) in
            if self.isSearchEnabled {
                self.searchResultArray = self.searchResultArray?.sorted(byKeyPath: "created", ascending: true)
            } else {
                self.tasks = self.tasks.sorted(byKeyPath: "created", ascending: true)
            }
            self.reloadTableView(withAnimation: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addAction(nameAction)
        alertController.addAction(priorityAction)
        alertController.addAction(creationDateAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {}
    }
    
    func reloadTableView(withAnimation:Bool) {
        if withAnimation {
            self.toDoTableView.reloadSections(NSIndexSet(index:0) as IndexSet, with: .fade)        }
        else{
            toDoTableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        animateNavigationBar()
        self.reloadTableView(withAnimation: true)
    }
    
    func animateNavigationBar() {
        self.view.endEditing(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if !isSearchEnabled { self.toDoTableView.setContentOffset(CGPoint(x: 0, y: 44), animated: false) }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        animateNavigationBar()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createTaskVC = storyboard.instantiateViewController(withIdentifier: "CreateOrEditTaskViewController") as! CreateOrEditTaskViewController
        createTaskVC.operationType = .Edit
        createTaskVC.taskItem = isSearchEnabled ? searchResultArray![indexPath.row] : tasks[indexPath.row]
        self.navigationController?.pushViewController(createTaskVC, animated: true)
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = isSearchEnabled ? searchResultArray![indexPath.row] : tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! toDoTableViewCell
        cell.initWithTask(task: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = isSearchEnabled ? searchResultArray?.count ?? 0 : tasks.count
        if itemCount > 0 {
            tableView.separatorStyle = .singleLine
            self.removeErrorMessage()
            return itemCount
        }
        tableView.separatorStyle = .none
        self.addErrorMessage()
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func addErrorMessage() {
        self.removeErrorMessage()
        noDataErrorLabel = UILabel.init(frame: CGRect(x: 0, y: self.view.center.y-100, width: self.view.frame.size.width, height: 40))
        noDataErrorLabel?.numberOfLines = 2
        noDataErrorLabel?.textAlignment = .center
        noDataErrorLabel?.text = "No Task available, Please make some."
        self.view.addSubview(noDataErrorLabel!)
    }
    
    func removeErrorMessage() {
        noDataErrorLabel?.removeFromSuperview()
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! tasks.realm!.write {
                let task = (isSearchEnabled) ? self.searchResultArray![indexPath.row] : self.tasks[indexPath.row]
                self.tasks.realm!.delete(task)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension DashboardViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchEnabled = true
        searchResultArray = (searchText.isEmpty) ? tasks : tasks.filter("title contains[c] %@",searchText)
        self.reloadTableView(withAnimation: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearchEnabled = false
        self.reloadTableView(withAnimation: true)
        UIView.animate(withDuration: 0.5) {
            self.searchBar.text = ""
            self.animateNavigationBar()
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        return true
    }
}

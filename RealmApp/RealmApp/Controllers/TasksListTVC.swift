//  TasksListTVC.swift
//  RealmApp
//  Created by Carolina on 11.01.23.

import UIKit
import RealmSwift

final class TasksListTVC: UITableViewController {
    
    var tasksList: Results<TasksList>!
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        
        //StorageManager.deleteAll()
        
        tasksList = StorageManager.getAllTasksLists().sorted(byKeyPath: "name")
        
        let add = UIBarButtonItem(barButtonSystemItem: .add,
                                  target: self,
                                  action: #selector (addBarButtonSystemItemSelector))
        
        self.navigationItem.setRightBarButtonItems([add, editButtonItem], animated: true)
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let taskList = tasksList[indexPath.row]
        cell.textLabel?.text = taskList.name
        cell.detailTextLabel?.text = taskList.tasks.count.description
        return cell
    }
    
    // MARK: - Table view delegate
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentList = tasksList[indexPath.row]
        
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteList(currentList)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editContextItem = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
            self.alertForAddAndUpdatesListTasks(currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        let doneContextItem = UIContextualAction(style: .destructive, title: "Done") { _, _, _ in
            
        }
        
        deleteContextItem.backgroundColor = .init(red: 107, green: 41, blue: 47)
        editContextItem.backgroundColor = .init(red: 96, green: 89, blue: 159)
        doneContextItem.backgroundColor = .init(red: 143, green: 113, blue: 140)
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem, editContextItem, doneContextItem])
        return swipeActions
    }
    
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        let byKeyPath = sender.selectedSegmentIndex == 0 ? "name" : "date"
        
        tasksList = tasksList.sorted(byKeyPath: byKeyPath)
        tableView.reloadData()
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // MARK: - Private func
    private func setupSegmentedControl() {
        let titleTextUnselectedControl = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 40, green: 15, blue: 84)]
        segmentedControl.setTitleTextAttributes(titleTextUnselectedControl, for:.normal)
        
        let titleTextSelectedControl = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 189, green: 177, blue: 211)]
        segmentedControl.setTitleTextAttributes(titleTextSelectedControl, for:.selected)
    }
    
    @objc func addBarButtonSystemItemSelector() {
        alertForAddAndUpdatesListTasks { [weak self] in
            print("List was added or edited")
            self?.tableView.reloadData()
        }
    }
    
    private func alertForAddAndUpdatesListTasks(_ tasksList: TasksList? = nil,
                                                complition: @escaping () -> Void) {
        
        let title = tasksList == nil ? "New List" : "Edit List"
        let message = "Please insert list name"
        let doneButtonName = tasksList == nil ? "Save" : "Update"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var alertTextField: UITextField!
        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { _ in
            
            guard let newListName = alertTextField.text,
                  !newListName.isEmpty else {
                return
            }
            
            /// логика редактирования
            if let tasksList = tasksList {
                StorageManager.editTasksList(tasksList, newListName: newListName, complition: complition)
            /// логика создания нового списка
            } else {
                let tasksList = TasksList()
                tasksList.name = newListName
                StorageManager.saveTasksList(tasksList: tasksList)
                complition()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        cancelAction.setValue(UIColor.init(red: 107, green: 41, blue: 47), forKey: "titleTextColor")
        saveAction.setValue(UIColor.init(red: 40, green: 15, blue: 84), forKey: "titleTextColor")
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            alertTextField = textField
            if let listName = tasksList {
                alertTextField.text = listName.name
            }
            alertTextField.placeholder = "List Name"
        }
        self.present(alert, animated: true)
    }
}

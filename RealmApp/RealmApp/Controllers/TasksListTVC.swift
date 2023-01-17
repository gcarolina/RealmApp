//  TasksListTVC.swift
//  RealmApp
//  Created by Carolina on 11.01.23.

import UIKit
import RealmSwift

final class TasksListTVC: UITableViewController {
    
    var tasksList: Results<TasksList>!
    var notificationToken: NotificationToken?
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupSegmentedControl()
    
        //StorageManager.deleteAll()
        tasksList = StorageManager.getAllTasksLists().sorted(byKeyPath: TextForKeyPath.name.rawValue)
        addTasksListsObserver()
        
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
        
        cell.configure(with: taskList)
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentList = tasksList[indexPath.row]
        
        let deleteContextItem = UIContextualAction(style: .destructive, title: TextForContextItem.delete.rawValue) { _, _, _ in
            StorageManager.deleteList(currentList)
        }
        
        let editContextItem = UIContextualAction(style: .destructive, title: TextForContextItem.edit.rawValue) { _, _, _ in
            self.alertForAddAndUpdatesListTasks(tasksListTVCFlow: .editingList(taskList: currentList))
        }
        
        let doneContextItem = UIContextualAction(style: .destructive, title: TextForContextItem.done.rawValue) { _, _, _ in
            StorageManager.makeAllDone(currentList)
        }
        
        deleteContextItem.backgroundColor = .init(red: 107, green: 29, blue: 46)
        editContextItem.backgroundColor = .init(red: 79, green: 56, blue: 139)
        doneContextItem.backgroundColor = .init(red: 97, green: 60, blue: 106)
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem, editContextItem, doneContextItem])
        return swipeActions
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        let byKeyPath = sender.selectedSegmentIndex == 0 ? TextForKeyPath.name.rawValue : TextForKeyPath.date.rawValue
        tasksList = tasksList.sorted(byKeyPath: byKeyPath)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskList = tasksList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "TasksTVC") as? TasksTVC else { return }
        vc.currentTasksList = taskList
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Private func-s
    
    private func setupSegmentedControl() {
        let titleTextUnselectedControl = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 40, green: 15, blue: 84)]
        segmentedControl.setTitleTextAttributes(titleTextUnselectedControl, for:.normal)
        
        let titleTextSelectedControl = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 189, green: 177, blue: 211)]
        segmentedControl.setTitleTextAttributes(titleTextSelectedControl, for:.selected)
    }
    
    private func addTasksListsObserver() {
        // Realm notification
        notificationToken = tasksList.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                print("initial element")
            case .update(_, let deletions, let insertions, let modifications):
                if !modifications.isEmpty {
                    let indexPathArray = self.createIndexPathArray(values: modifications)
                    //self.tableView.reloadRows(at: indexPathArray, with: .automatic)
                    self.tableView.reloadData()
                }
                if !deletions.isEmpty {
                    let indexPathArray = self.createIndexPathArray(values: deletions)
                    self.tableView.deleteRows(at: indexPathArray,
                                              with: .automatic)
                }
                if !insertions.isEmpty {
                    let indexPathArray = self.createIndexPathArray(values: insertions)
                    self.tableView.insertRows(at: indexPathArray,
                                              with: .automatic)
                }
            case .error(let error):
                print("error: \(error)")
            }
        }
    }
    
    private func createIndexPathArray(values: [Int]) -> [IndexPath] {
        var indexPathArray = [IndexPath]()
        for row in values {
            indexPathArray.append(IndexPath(row: row, section: 0))
        }
        return indexPathArray
    }
}

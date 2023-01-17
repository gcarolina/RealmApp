//  TasksTVC.swift
//  RealmApp
//  Created by Carolina on 15.01.23.

import UIKit
import RealmSwift

enum Sections: Int {
    case firstSection = 0
    case secondSection = 1
}

final class TasksTVC: UITableViewController {
    var notificationTokenForTask: NotificationToken?
    var currentTasksList: TasksList?
    
    private var notCompletedTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title
        title = currentTasksList?.name
        filteringTask()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add,
                                  target: self,
                                  action: #selector (addBarButtonSystemItemSelector))
        
        self.navigationItem.setRightBarButtonItems([add, editButtonItem], animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? notCompletedTasks.count : completedTasks.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? TitleTaskForHeaderInSection.notCompleted.rawValue : TitleTaskForHeaderInSection.completed.rawValue
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        //For Header Background Color
        view.tintColor = .init(red: 61, green: 49, blue: 96)
        
        // For Header Text Color
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .init(red: 187, green: 175, blue: 211)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]

        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let deleteContextItem = UIContextualAction(style: .destructive, title: TextForTasksTextForContextItem.delete.rawValue) { _, _, _ in
            StorageManager.deleteTask(task)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editContextItem = UIContextualAction(style: .destructive, title: TextForTasksTextForContextItem.edit.rawValue) { _, _, _ in
            self.alertForAddAndUpdatesList(tasksTVCFlow: .editingTask(task: task))
        }
        
        let doneText = task.isComplete ? TextForTasksTextForContextItem.notDone.rawValue : TextForTasksTextForContextItem.done.rawValue
        let doneContextItem = UIContextualAction(style: .destructive, title: doneText) { _, _, _ in
            StorageManager.makeDoneOrMoveCell(task)
            self.filteringTask()
        }
        
        deleteContextItem.backgroundColor = .init(red: 107, green: 29, blue: 46)
        editContextItem.backgroundColor = .init(red: 79, green: 56, blue: 139)
        doneContextItem.backgroundColor = .init(red: 97, green: 60, blue: 106)
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem, editContextItem, doneContextItem])
        return swipeActions
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        guard let completedTasks = completedTasks, let completedTasksArray = Array(completedTasks) as? [Task],
              let notCompletedTasks = notCompletedTasks, let notCompletedTasksArray = Array(notCompletedTasks) as? [Task] else { return }
        
        if to.section != fromIndexPath.section {
            if to.section == Sections.firstSection.rawValue {
                movingCell(fromTasksArray: completedTasksArray, toTasksArray: notCompletedTasksArray, fromIndexPath: fromIndexPath, to: to)
            } else if to.section == Sections.secondSection.rawValue {
                movingCell(fromTasksArray: notCompletedTasksArray, toTasksArray: completedTasksArray, fromIndexPath: fromIndexPath, to: to)
            }
        }
    }

    func filteringTask() {
        notCompletedTasks = currentTasksList?.tasks.filter("isComplete = false")
        completedTasks = currentTasksList?.tasks.filter("isComplete = true")
        tableView.reloadData()
    }
    
    private func movingCell(fromTasksArray: [Task]?, toTasksArray: [Task]?, fromIndexPath: IndexPath, to: IndexPath) {
        guard var fromTasksArray = fromTasksArray, var toTasksArray = toTasksArray else { return }
        let currentTask = fromTasksArray.remove(at: fromIndexPath.row)
        toTasksArray.insert(currentTask, at: to.row)
        StorageManager.makeDoneOrMoveCell(currentTask)
    }
}

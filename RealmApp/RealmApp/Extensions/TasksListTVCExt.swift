//  TasksListTVCExt.swift
//  RealmApp
//  Created by Carolina on 16.01.23.

import UIKit
import RealmSwift

extension TasksListTVC {
    @objc func addBarButtonSystemItemSelector() {
        alertForAddAndUpdatesListTasks(tasksListTVCFlow: .addingNewTask)
        }
        
    func alertForAddAndUpdatesListTasks(tasksListTVCFlow: TasksListTVCFlow) {
    
        let textForAlert = TextForListAlert(tasksListTVCFlow: tasksListTVCFlow)
       
        let alert = UIAlertController(title: textForAlert.titleForAlert, message: textForAlert.messageForAlert, preferredStyle: .alert)
        
        ///TextFields
        var alertTextField: UITextField!
        
        alert.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = textForAlert.textFieldPlaceholder
            alertTextField.text = textForAlert.listName
        }
        
        ///Actions
        let saveAction = UIAlertAction(title: textForAlert.doneButtonNameForAlert, style: .default) { _ in
            
            guard let newListName = alertTextField.text,
                  !newListName.isEmpty else {
                return
            }
            
            switch tasksListTVCFlow {
                /// логика создания нового списка
            case .addingNewTask:
                let tasksList = TasksList()
                tasksList.name = newListName
                StorageManager.saveTasksList(tasksList: tasksList)
                
                /// логика редактирования
            case .editingList(let taskList):
                StorageManager.editTasksList(taskList,
                                             newListName: newListName)
            }
        }
        
        let cancelAction = UIAlertAction(title: textForAlert.cancelForAlert, style: .destructive)
        cancelAction.setValue(UIColor.init(red: 107, green: 41, blue: 47), forKey: "titleTextColor")
        saveAction.setValue(UIColor.init(red: 40, green: 15, blue: 84), forKey: "titleTextColor")
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }
}

//  TasksTVCExt.swift
//  RealmApp
//  Created by Carolina on 15.01.23.

import UIKit
import RealmSwift

extension TasksTVC {
    @objc func addBarButtonSystemItemSelector() {
        alertForAddAndUpdatesList()
    }
    
    func alertForAddAndUpdatesList(_ taskForEditing: Task? = nil) {
        
        let title = "New task"
        let message = (taskForEditing == nil) ? "Please insert new task value" : "Please edit your task"
        let doneButtonName = (taskForEditing == nil) ? "Save" : "Update"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { _ in
            
            guard let newNameTask = taskTextField.text, !newNameTask.isEmpty,
                  let newNoteTask = noteTextField.text, !newNoteTask.isEmpty else { return }
            
            /// логика редактирования
            if let taskForEditing = taskForEditing {
                StorageManager.editTask(taskForEditing,
                                        newTaskName: newNameTask,
                                        newNote: newNoteTask)
                /// логика создания нового списка
            } else {
                let task = Task()
                task.name = newNameTask
                task.note = newNoteTask
                StorageManager.saveTask(self.currentTasksList, task: task)
            }
            self.filteringTask()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        cancelAction.setValue(UIColor.init(red: 107, green: 41, blue: 47), forKey: "titleTextColor")
        saveAction.setValue(UIColor.init(red: 40, green: 15, blue: 84), forKey: "titleTextColor")
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            taskTextField = textField
            if let task = taskForEditing {
                taskTextField.text = task.name
            }
            taskTextField.placeholder = "Task"
        }
        
        alert.addTextField { textField in
            noteTextField = textField
            if let task = taskForEditing {
                noteTextField.text = task.note
            }
            noteTextField.placeholder = "Note"
        }
        self.present(alert, animated: true)
    }
}

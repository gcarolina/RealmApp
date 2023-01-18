//  TasksTVCExt.swift
//  RealmApp
//  Created by Carolina on 15.01.23.

import UIKit
import RealmSwift

extension TasksTVC {
    @objc func addBarButtonSystemItemSelector() {
        alertForAddAndUpdatesList(tasksTVCFlow: .addingNewTask)
    }
    
    func alertForAddAndUpdatesList(tasksTVCFlow: TasksTVCFlow) {
        
        let textForAlert = TextForTaskAlert(tasksTVCFlow: tasksTVCFlow)
        
        let alert = UIAlertController(title: textForAlert.titleForAlert,
                                      message: textForAlert.messageForAlert,
                                      preferredStyle: .alert)
        
        ///TextFields
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        
        alert.addTextField { textField in
            taskTextField = textField
            taskTextField.placeholder = textForAlert.titleTextFieldPlaceholder
            taskTextField.text = textForAlert.taskName
        }
        
        alert.addTextField { textField in
            noteTextField = textField
            noteTextField.placeholder = textForAlert.noteTextFieldPlaceholder
            noteTextField.text = textForAlert.taskNote
        }
        
        ///Actions
        let saveAction = UIAlertAction(title: textForAlert.doneButtonNameForAlert,
                                       style: .default) { [weak self] _ in
            
            guard let newNameTask = taskTextField.text, !newNameTask.isEmpty,
                  let newNoteTask = noteTextField.text, !newNoteTask.isEmpty,
                  let self = self else { return }
           
            switch tasksTVCFlow {
                /// логика создания нового списка
            case .addingNewTask:
                let task = Task()
                task.name = newNameTask
                task.note = newNoteTask
                guard let currentTasksList = self.currentTasksList else { return }
                StorageManager.saveTask(currentTasksList, task: task)
                /// логика редактирования
            case .editingTask(let task):
                StorageManager.editTask(task,
                                        newTaskName: newNameTask,
                                        newNote: newNoteTask)
            }
            self.filteringTask()
        }
        
        let cancelAction = UIAlertAction(title: textForAlert.cancelForAlert, style: .destructive)
        cancelAction.setValue(UIColor.init(red: 107, green: 41, blue: 47), forKey: "titleTextColor")
        saveAction.setValue(UIColor.init(red: 40, green: 15, blue: 84), forKey: "titleTextColor")
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}

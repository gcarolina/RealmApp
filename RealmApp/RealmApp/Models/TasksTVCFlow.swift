//  TasksTVCFlow.swift
//  RealmApp
//  Created by Carolina on 16.01.23.

import UIKit

enum TextForTasksTextForContextItem: String {
    case delete = "Delete"
    case edit = "Edit"
    case done = "Done"
    case notDone = "Not done"
}

enum TitleTaskForHeaderInSection: String {
    case completed = "Completed tasks"
    case notCompleted = "Not completed tasks"
}

enum TasksTVCFlow {
    case addingNewTask
    case editingTask(task: Task)
}

struct TextForTaskAlert {
    let titleForAlert = "New task"
    let cancelForAlert = "Cancel"
    var messageForAlert: String
    var doneButtonNameForAlert: String
    
    let titleTextFieldPlaceholder = "New task"
    let noteTextFieldPlaceholder = "Note"
    
    var taskName: String?
    var taskNote: String?
    
    init(tasksTVCFlow: TasksTVCFlow) {
        switch tasksTVCFlow {
        case .addingNewTask:
            messageForAlert = "Please insert new task value"
            doneButtonNameForAlert = "Save"
        case .editingTask(let task):
            messageForAlert = "Please edit your task"
            doneButtonNameForAlert = "Update"
            taskName = task.name
            taskNote = task.note
        }
    }
}

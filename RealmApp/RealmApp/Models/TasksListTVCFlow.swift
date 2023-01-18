//  TasksListTVCFlow.swift
//  RealmApp
//  Created by Carolina on 16.01.23.

import UIKit

enum TextForContextItem: String {
    case delete = "Delete"
    case edit = "Edit"
    case done = "Done"
}

enum TextForKeyPath: String {
    case name
    case date
}

enum TasksListTVCFlow {
    case addingNewTask
    case editingList(taskList: TasksList)
}

struct TextForListAlert {
    
    let cancelForAlert = "Cancel"
    
    var titleForAlert: String
    var messageForAlert: String
    var doneButtonNameForAlert: String
    
    let textFieldPlaceholder = "List Name"
    
    var listName: String?
    
    init(tasksListTVCFlow: TasksListTVCFlow) {
        switch tasksListTVCFlow {
        case .addingNewTask:
            titleForAlert = "New List"
            messageForAlert = "Please insert new list"
            doneButtonNameForAlert = "Save"
        case .editingList(let taskList):
            titleForAlert = "Edit List"
            messageForAlert = "Please edit your list"
            doneButtonNameForAlert = "Update"
            listName = taskList.name
        }
    }
}

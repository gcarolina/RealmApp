//  StorageManager.swift
//  RealmApp
//  Created by Carolina on 11.01.23.

import Foundation
import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("deleteAll error: \(error)")
        }
    }
    
    static func deleteList(_ tasksList: TasksList) {
        do {
            try realm.write {
                let tasks = tasksList.tasks
                // последовательно удаляем tasks и tasksList
                realm.delete(tasks)
                realm.delete(tasksList)
            }
        } catch {
            print("deleteList error: \(error)")
        }
    }

    static func getAllTasksLists() -> Results<TasksList> {
        realm.objects(TasksList.self)
    }
    
    static func editTasksList(_ tasksList: TasksList,
                              newListName: String) {
        do {
            try realm.write {
                tasksList.name = newListName
            }
        } catch {
            print("editList error: \(error)")
        }
    }
    
    static func saveTasksList(tasksList: TasksList) {
        do {
            try realm.write {
                realm.add(tasksList)
            }
        } catch {
            print("saveTasksList error: \(error)")
        }
    }
    
    static func makeAllDone(_ taskList: TasksList) {
        do {
            try realm.write {
                taskList.tasks.setValue(true, forKey: "isComplete")
            }
        } catch {
            print("makeAllDone error: \(error)")
        }
    }
    
    
    // MARK: - Tasks Methods
    
    static func saveTask(_ taskList: TasksList?, task: Task) {
        do {
            try realm.write {
                guard let taskList = taskList else { return }
                taskList.tasks.append(task)
            }
        } catch {
            print("saveTask error: \(error)")
        }
    }
    
    static func editTask(_ task: Task, newTaskName: String, newNote: String) {
        do {
            try realm.write {
                task.name = newTaskName
                task.note = newNote
            }
        } catch {
            print("editTask error: \(error)")
        }
    }
    
    static func deleteTask(_ task: Task) {
        do {
            try realm.write {
                realm.delete(task)
            }
        } catch {
            print("deleteTask error: \(error)")
        }
    }
    
    static func makeDone(_ task: Task) {
        do {
            try realm.write {
                task.isComplete.toggle()
            }
        } catch {
            print("makeDoneTask error: \(error)")
        }
    }
}

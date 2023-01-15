//  UITableViewCellExt.swift
//  RealmApp
//  Created by Carolina on 15.01.23.

import UIKit

extension UITableViewCell {
    func configure(with tasksList: TasksList) {
        let notCompletedTasks = tasksList.tasks.filter("isComplete = false")
        let completedTasks = tasksList.tasks.filter("isComplete = true")

        textLabel?.text = tasksList.name

        if !notCompletedTasks.isEmpty {
            detailTextLabel?.text = "\(tasksList.tasks.count)"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
            detailTextLabel?.textColor = .init(red: 189, green: 177, blue: 211)
        } else if !completedTasks.isEmpty {
            detailTextLabel?.text = "✓"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            detailTextLabel?.textColor = .init(red: 162, green: 211, blue: 177)
        } else {
            detailTextLabel?.text = "0"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            detailTextLabel?.textColor = .init(red: 187, green: 175, blue: 211)
        }
    }
}

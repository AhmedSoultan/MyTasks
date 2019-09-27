//
//  SwipeCellTableViewController.swift
//  MyTask
//
//  Created by Ahmed Sultan on 9/27/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeCellTableViewController: UITableViewController, SwipeTableViewCellDelegate {

override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 80.0
    tableView.separatorStyle = .none

}

// MARK: - Table view data source

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SwipeTableViewCell
    cell.delegate = self
    return cell
}

func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }

    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
        // handle action by updating model with deletion
        self.updateCell(at: indexPath)
    }

    // customize the action appearance
    deleteAction.image = UIImage(named: "trash-circle")

    return [deleteAction]
}

func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
    var options = SwipeOptions()
    options.expansionStyle = .destructive
    options.transitionStyle = .border
    return options
}
func updateCell(at indexPath: IndexPath) {
    
}
}

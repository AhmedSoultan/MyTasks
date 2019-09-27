//
//  TableViewController.swift
//  MyTask
//
//  Created by Ahmed Sultan on 9/23/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import UIKit
import RealmSwift

class TodoTableViewController: SwipeCellTableViewController {
//MARK: - Properties

var items: Results<Item>?
let realm = try! Realm()
var selectedCategory: Category?

override func viewDidLoad() {
    super.viewDidLoad()
    loadItems()
}

// MARK: - Table view data source

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items?.count ?? 1
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    if let item = items?[indexPath.row] {
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
    }
 
    return cell
}

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let item = items?[indexPath.row] {
        do {
            try self.realm.write {
                 item.done.toggle()
            }
        } catch {
            print("error updating itme \(error)")
        }
        tableView.reloadData()
    }
}

override func updateCell(at indexPath: IndexPath) {
     if let item = self.items?[indexPath.row] {
                   do {
                       try self.realm.write {
                           self.realm.delete(item)
                       }
                   } catch {
                       print("error deleting item \(error)")
                   }
               }
}
//MARK: - Custom actions

@IBAction func addButtonAction(_ sender: Any) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: UIAlertController.Style.alert)
    alert.addTextField { (addTextField) in
        addTextField.placeholder = "Create new item"
        textField = addTextField
    }
    alert.addAction(UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { (action) in
        let item = Item()
        if let currentCategory = self.selectedCategory {
            do {
                item.title = textField.text!
                item.date = Date()
                try self.realm.write {
                    currentCategory.items.append(item)
                }
            } catch {
               print("error saving items \(error)")
            }
            self.tableView.reloadData()
        }
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
    present(alert, animated: true, completion: nil)
}

func loadItems() {
    items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    tableView.reloadData()
}

}
extension TodoTableViewController: UISearchBarDelegate {
func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton.toggle()
}

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
   searchBar.showsCancelButton.toggle()
    tableView.reloadData()
}

func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = nil
    searchBar.showsCancelButton.toggle()
    searchBar.resignFirstResponder()
    loadItems()
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
        searchBar.showsCancelButton.toggle()
        loadItems()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
}

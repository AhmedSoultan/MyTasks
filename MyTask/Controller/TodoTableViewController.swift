//
//  TableViewController.swift
//  MyTask
//
//  Created by Ahmed Sultan on 9/23/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController: UITableViewController {
    //MARK: - Properties
    var items = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.row].done.toggle()
        saveItems()
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: UIContextualAction.Style.normal, title: "Delete") { (action, view, (Bool) -> Void) in
            self.context.delete(self.items[indexPath.row])
            self.items.remove(at: indexPath.row)
            self.saveItems()
        }
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
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
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            self.items.append(item)
            self.saveItems()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
           try context.save()
        } catch {
            print("error saving items \(error)")
        }
        tableView.reloadData()
    }
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            items = try context.fetch(request)
            print(self.items)
        } catch {
            print("error loading items \(error)")
        }
        tableView.reloadData()
    }
    
}
extension TodoTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
       // request.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        loadItems(with: request)
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        loadItems()
        tableView.reloadData()
    }
}

//
//  TableViewController.swift
//  MyTask
//
//  Created by Ahmed Sultan on 9/23/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController {
    
    //MARK: - Properties
    var items = [Item]()
    var filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")

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
            item.title = textField.text!
            item.done = false
            self.items.append(item)
            self.saveItems()
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    func saveItems() {
        let encoder = PropertyListEncoder()
        let data = try? encoder.encode(self.items)
        do {
           try data?.write(to: filePath!)
        } catch {
            print("error saving items \(error)")
        }
        tableView.reloadData()
    }
    func loadItems() {
        let decoder = PropertyListDecoder()
        do {
        let data = try Data(contentsOf: filePath!)
        self.items = try decoder.decode([Item].self, from: data)
        } catch {
            print("error loading items \(error)")
        }
        tableView.reloadData()
    }
    
}

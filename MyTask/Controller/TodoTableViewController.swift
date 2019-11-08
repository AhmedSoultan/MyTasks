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
    
@IBOutlet weak var searchBar: UISearchBar!
    
//MARK: - Properties

var items: Results<Item>?
let realm = try! Realm()
var selectedCategory: Category?

//MARK; - View life cycle
    
override func viewDidLoad() {
    super.viewDidLoad()
    loadItems()
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateColors()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let originalColor = UIColor.flatRed() else {fatalError()}
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = UIColor.flatBlack()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.flatBlack()]
    }

// MARK: - Table view data source

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items?.count ?? 1
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    if let items = items, let currentCategory = selectedCategory {
        let item = items[indexPath.row]
        let colour = UIColor.init(hexString: currentCategory.colour!)
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        cell.backgroundColor = colour?.lighten(byPercentage: CGFloat(indexPath.row) / CGFloat(items.count))
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: colour!, isFlat: true)
        //cell.backgroundColor = colour!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items.count))
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
func updateColors() {
    guard let navBar = navigationController?.navigationBar,
          let currentCategory = selectedCategory,
        let colour = UIColor(contrastingBlackOrWhiteColorOn: UIColor.init(hexString: currentCategory.colour), isFlat: true) else {fatalError("error updating colours")}
    navBar.barTintColor = UIColor.init(hexString: currentCategory.colour)
    navBar.tintColor = colour
    searchBar.barTintColor = UIColor.init(hexString: currentCategory.colour)
    navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : colour]
    title = currentCategory.name
    
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

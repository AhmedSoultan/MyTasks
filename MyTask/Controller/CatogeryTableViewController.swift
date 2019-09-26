//
//  CatogeryTableViewController.swift
//  MyTask
//
//  Created by Ahmed Sultan on 9/25/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import UIKit
import RealmSwift

class CatogeryTableViewController: UITableViewController {
    
    //MARK: - Properties
    var categories: Results<Category>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemsVC", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: UIContextualAction.Style.normal, title: "delete") { (action, view, completed) in
            if let category = self.categories?[indexPath.row] {
                
                do {
                    try self.realm.write {
                    self.realm.delete(category)
                    }
                } catch {
                    print("error deletig category \(error)")
                }
            }
            tableView.reloadData()
    }
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let todoVC = segue.destination as! TodoTableViewController
        let indexPath = tableView.indexPathForSelectedRow!
        todoVC.selectedCategory = categories?[indexPath.row]
    }
    
    //MARK: - Custom actions
    @IBAction func addCategory(_ sender: Any) {
        var textField = UITextField()
               let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: UIAlertController.Style.alert)
               alert.addTextField { (addTextField) in
                   addTextField.placeholder = "Create new item"
                   textField = addTextField
               }
               alert.addAction(UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { (action) in
                let newCategory = Category()
                newCategory.name = textField.text!
                self.save(category: newCategory)
               }))
               alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
               present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
         categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}
extension CatogeryTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton.toggle()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        categories = categories?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton.toggle()
        searchBar.text = nil
        searchBar.resignFirstResponder()
        loadCategories()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            searchBar.showsCancelButton = false
            searchBar.text = nil
            loadCategories()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

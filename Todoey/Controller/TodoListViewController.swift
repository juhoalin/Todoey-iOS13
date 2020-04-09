//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    let defaults = UserDefaults.standard
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
                
        searchController.searchResultsUpdater = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController

        
        searchController.searchBar.tintColor = .gray
        
        definesPresentationContext = true
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        

    }
    
    //MARK: - tableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
                
        cell.textLabel?.text = task.name
        cell.tintColor = .systemTeal
        
        cell.accessoryType = task.done  ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - tableViewDelegateMethdods
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
               
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
                    
        
        }
    
    //MARK: - Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Item", message: "What do you want to do?", preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addTextField { (textField) in
            textField.keyboardType = .default
            textField.placeholder = "Buy some milk"
                    }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { (action) in
            let textField = alert.textFields![0]
            if let text = textField.text {
                let newItem = Item(context: self.context)
                newItem.name = text
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                self.saveItems()
            }
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
            
        do {
            try context.save()
        } catch {
            print("Error in new Item \(error)")
        }
        self.tableView.reloadData()

        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
        itemArray = try context.fetch(request)
        } catch {
            print("Error in fetching new Item \(error)")
        }
        tableView.reloadData()
    }
    

    
   
    
    }

extension TodoListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        if isFiltering {
            filterContentForSearchBar(searchBar)
        } else {
            loadItems()
        }
        
    }
    
    
    
    func filterContentForSearchBar(_ searchBar: UISearchBar) {
        
        let itemRequest : NSFetchRequest<Item> = Item.fetchRequest()
    
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        itemRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadItems(with: itemRequest, predicate: predicate)

        
    }
    
    
}




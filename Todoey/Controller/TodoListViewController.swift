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
    
    let defaults = UserDefaults.standard

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                
            loadItems()

    }
    
    //MARK: - tableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        
        //cell.textLabel?.text = task
        
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
    
    func loadItems() {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
        itemArray = try context.fetch(request)
        } catch {
            print("Error in fetching new Item \(error)")
        }
    }
    

    
   
    
    }




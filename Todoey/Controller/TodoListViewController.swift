//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    

    
    var itemArray = [ItemDataModel]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")


    override func viewDidLoad() {
        super.viewDidLoad()
                
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
                let newItem = ItemDataModel()
                newItem.name = text
                self.itemArray.append(newItem)
                self.saveItems()
            }
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error in encoding itemArray \(error)")
        }
        self.tableView.reloadData()

        
    }
    
    func loadItems() {


    if let data = try? Data(contentsOf:
    dataFilePath!) {
    let decoder = PropertyListDecoder()
    do {
        itemArray = try decoder.decode([ItemDataModel].self, from: data)

    } catch {
    print("Error in decoding the itemArray \(error)")
    }

    }
        
    }
    

    
   
    
    }




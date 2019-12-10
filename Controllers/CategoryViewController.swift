//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Vanya Mutafchieva on 28/11/2019.
//  Copyright © 2019 Vanya Mutafchieva. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var colorArray = ColorSchemeOf(ColorScheme.analogous, color: FlatGreen(), isFlatScheme: true)
    
    var categoryArray: Results<Categorie>?
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // XCode Treasures
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "BACKEND_URL") else {
            print("couldn't get BACKEND_URL")
            return
        }
        print("Backend url is \(urlString)")
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let colorHex = categoryArray?[0].hexColor {
            
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller does not exist")
            }
            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.backgroundColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                view.backgroundColor = navBarColor
            }
        }
        
       
    }
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            let newCategory = Categorie()
            newCategory.name = textField.text!
            newCategory.hexColor = UIColor.randomFlat().hexValue()
            //newCategory.hexColor = self.colorArray[Int(arc4random_uniform(4))].hexValue()
            self.save(category: newCategory)
            
        }
       
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
    
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        
        let colorString = categoryArray?[indexPath.row].hexColor ?? "6EFFFF"
        
        if let uiColor = UIColor(hexString: colorString) {
            cell.backgroundColor = uiColor
            cell.textLabel?.textColor = ContrastColorOf(uiColor, returnFlat: true)
        }
        return cell
        
    }
    
    // MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    // MARK: - Model Manipulation Methods
    
    func save(category: Categorie) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
           print("Error saving category \(error)")
        }
    
        self.tableView.reloadData()
    }
    
    func loadCategories() {

        categoryArray = realm.objects(Categorie.self)
        tableView.reloadData()
    }
    
    // MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        //super.updateModel(at: indexPath)
        
        if let category = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
            //tableView.reloadData()
        }
    }

}


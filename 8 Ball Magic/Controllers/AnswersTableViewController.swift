//
//  AnswersTableViewController.swift
//  8 Ball Magic
//
//  Created by Игорь Антонченко on 18.10.2021.
//

import UIKit

class AnswersTableViewController: UITableViewController {
    
    var dataFilePath: URL?
    var answers: [String] = [""]
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answersCell", for: indexPath)
        cell.textLabel?.text = answers[indexPath.row]
        return cell
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            answers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    

    //MARK: - Add answer Button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new answer", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { [weak alert, weak self] (action) in
            
            guard let self = self else { return }
            guard let textFieldText = alert?.textFields?.first?.text else { return }
            
            self.answers.append(textFieldText)
            self.tableView.reloadData()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (actionCancel) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        alert.addAction(actionCancel)
        alert.addTextField { (field) in
            field.placeholder = "Add a new answer"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Save data to the memory
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.answers)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("error to encode data \(error)")
        }
    }
}

//
//  LensesTableViewController.swift
//  LensCounter
//
//  Created by Brent Eerlingen on 2/07/17.
//  Copyright © 2017 Brent Eerlingen. All rights reserved.
//

import UIKit
import os.log

class LensesTableViewController: UITableViewController {
    var lenses = [Lens]()
    @IBOutlet weak var lensesTableView: UITableView!
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddLensViewController, let lens = sourceViewController.lens {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                if lens.isActivated {
                    for lens1 in lenses {
                        lens1.isActivated = false
                    }
                   
                }
                lenses[selectedIndexPath.row] = lens
                //lensesTableView.reloadRows(at: [selectedIndexPath], with: .none)
                //lensesTableView.reloadData()
                DispatchQueue.main.async(execute: {
                    
                    
                    self.lensesTableView.reloadData()})
            }
            else {
                // Add a new lens.
                let newIndexPath = IndexPath(row: lenses.count, section: 0)
                
                if lens.isActivated {
                    for lens1 in lenses {
                        lens1.isActivated = false
                    }
                    //self.lensesTableView.reloadData()
                }
                
                lenses.append(lens)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                //lensesTableView.reloadData()

            }
            

            saveLenses()
        }
        
    }
    
    //MARK: Private methods
    private func loadSamples(){
        
         let photoPureVision = UIImage(named: "PureVision")
        
        guard let lens1 = Lens(brand: "PureVision", type: "Month",isActivated: true, photo: photoPureVision) else {
            fatalError("Unable to instantiate lens1")
        }
        
        guard let lens2 = Lens(brand: "Proclear", type: "Week",isActivated: false, photo: photoPureVision) else {
            fatalError("Unable to instantiate lens3")
        }
        
        guard let lens3 = Lens(brand: "SofLens", type: "Month",isActivated: false, photo: photoPureVision) else {
            fatalError("Unable to instantiate lens3")
        }
        
        lenses += [lens1, lens2, lens3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedLenses = loadLenses() {
            lenses += savedLenses
        } else {
            // Load the sample data.
            loadSamples()
        }
        lensesTableView.delegate = self
        lensesTableView.dataSource = self
       
        tableView.tableFooterView = UIView(frame: .zero)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func saveLenses(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(lenses, toFile: Lens.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Lenses successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save lenses...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadLenses() -> [Lens]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Lens.ArchiveURL.path) as? [Lens]
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lenses.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "LensTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LensTableViewCell else {
            fatalError("The dequeued cell is not an instance of LensTableViewCell.")
        }
        
        let lens = lenses[indexPath.row]
        
        cell.brandLens.text = lens.brand
        cell.typeLens.text = lens.type
        cell.counterLens.text =  lens.counter.description
        cell.imageLogoLens.image = lens.photo

        
        if lens.isActivated {
            cell.activatedLens.isHidden = false
        } else {
            cell.activatedLens.isHidden = true
        }
        
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            lenses.remove(at: indexPath.row)
            saveLenses()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new lens.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let lensDetailViewController = segue.destination as? AddLensViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? LensTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedLens = lenses[indexPath.row]
            lensDetailViewController.lens = selectedLens
            lensDetailViewController.title = selectedLens.brand
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }     }
    
    
}

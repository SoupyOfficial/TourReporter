//
//  InterestsTableViewController.swift
//  TipReporter
//
//  Created by Soupy Campbell on 4/25/23.
//

import UIKit

protocol InterestsTableViewControllerDelegate: AnyObject {
    func interestsTableViewController(_ controller: InterestsTableViewController, didSelectInterests interests: [String], interestsBool: Bool)
}

class InterestsTableViewController: UITableViewController {

    weak var delegate: InterestsTableViewControllerDelegate?
    var selectedInterests = [String]()
    var selectedRows = [Int]()
    var interestBool = Bool()


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        var updatedInterests = [String]()
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                updatedInterests.append(interests[indexPath.row])
            }
        }
        delegate?.interestsTableViewController(self, didSelectInterests: updatedInterests, interestsBool: interestBool)
        dismiss(animated: true, completion: nil)
        }

    
    var interests: [String] = []

    
    override func viewWillAppear(_ animated: Bool) {
        selectedRows.forEach { indexPath in
                    tableView.selectRow(at: IndexPath(row: indexPath, section: 0), animated: false, scrollPosition: .none)
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let interestsFileURL = Bundle.main.url(forResource: "Interests", withExtension: "txt") {
            if let interestsFile = try? String(contentsOf: interestsFileURL) {
                interests = interestsFile.components(separatedBy: "\n")
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return interests.count-1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell", for: indexPath) as! InterestTableViewCell

        cell.interestTitle.text = interests[indexPath.row]

        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//    }
//
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

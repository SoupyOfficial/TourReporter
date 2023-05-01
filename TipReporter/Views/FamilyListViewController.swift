//
//  ViewTipsViewController.swift
//  TipReporter
//
//  Created by Soupy Campbell on 4/20/23.
//

import UIKit
import FirebaseFirestore


class FamilyListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    var results = [[String: Any]]()
    var searchResults = [[String: Any]]()
    let firebase = Firebase()

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebase.loadData(searchText: "") { results in
            self.results = results
            self.tableView.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the table view
        return results.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyCell", for: indexPath) as! FamilyCell
        
        // Configure the cell with the data from the query result
        let result = results[indexPath.row]
        
        // Parse date from timestamp
        let date = (result["Date"] as? Timestamp)!.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d',' yyyy - h:mm a"
        
        cell.tourDateField.text = dateFormatter.string(from: date)
        cell.firstNameLabel.text = result["First Name"] as? String ?? ""
        cell.lastNameLabel.text = result["Last Name"] as? String ?? ""
        cell.reportedTipLabel.text = result["Reported Tip"] as? String ?? ""
        cell.actualTipLabel.text = result["Actual Tip"] as? String ?? ""
        cell.tourTypeLabel.text = result["Tour Type"] as? String ?? ""
        cell.easinessLabel.text = result["Easiness"] as? String ?? ""
        cell.nicenessLabel.text = result["Niceness"] as? String ?? ""
        cell.demandingLabel.text = result["Demandingness"] as? String ?? ""
        cell.linstenedLabel.text = result["Follow Directions"] as? String ?? ""
        cell.unorthodoxLabel.text = result["Weird Requests"] as? String ?? ""
        cell.mainFocusLabel.text = result["Main Focus"] as? String ?? ""
        cell.interestsLabel.text = result["Interests"] as? String ?? ""
        cell.nonInterestsLabel.text = result["Non-Interests"] as? String ?? ""
        cell.tourNotesLabel.text = result["Tour Notes"] as? String ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 715
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        firebase.loadData(searchText: searchText) { results in
            self.results = results
            self.tableView.reloadData()
        }
    }

}

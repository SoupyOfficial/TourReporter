//
//  ViewTipsViewController.swift
//  TipReporter
//
//  Created by Soupy Campbell on 4/20/23.
//

import UIKit
import FirebaseFirestore


class ViewTipsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    let db = Firestore.firestore()
    var results = [[String: Any]]()
    var searchResults = [[String: Any]]()
    
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
        loadData(searchText: "")
    }
    
    func loadData(searchText: String) {
        self.results.removeAll()
        let firstQuery = db.collection("Ashley")
            .whereField("First Name", isGreaterThanOrEqualTo: searchText)
            .whereField("First Name", isLessThanOrEqualTo: searchText + "\u{f8ff}")
            .order(by: "First Name")
            .order(by: "Last Name")
        let lastQuery = db.collection("Ashley")
            .whereField("Last Name", isGreaterThanOrEqualTo: searchText)
            .whereField("Last Name", isLessThanOrEqualTo: searchText + "\u{f8ff}")
            .order(by: "Last Name")
            .order(by: "First Name")
        firstQuery.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.results.append(document.data())
                }
                self.tableView.reloadData()
                self.removeDuplicates()
            }
        }
        lastQuery.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.results.append(document.data())
                }
                self.tableView.reloadData()
                //print("\n\nRESULTS PRE-REMOVAL\n\n", self.results)
                self.removeDuplicates()
                //print("\n\nRESULTS POST-REMOVAL\n\n", self.results)

            }
        }
    }

    func removeDuplicates() {
        var uniqueData = [[String: Any]]()
        var duplicateIds = Set<String>()
        
        for dict in self.results {
            if let id = dict["documentID"] as? String {
                if !duplicateIds.contains(id) {
                    uniqueData.append(dict)
                    duplicateIds.insert(id)
                }
            }
        }
        
        self.results = uniqueData
        self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewTipsCell", for: indexPath) as! ViewTipsTableViewCell
        
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
        loadData(searchText: searchText)
    }

}

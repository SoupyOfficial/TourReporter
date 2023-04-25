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
            }
        }
        lastQuery.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if !self.results.contains(where: { ($0["documentID"] as? String) == document.documentID }) {
                        self.results.append(document.data())
                    }
                }
                self.tableView.reloadData()
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewTipsCell", for: indexPath) as! ViewTipsTableViewCell
        
        // Configure the cell with the data from the query result
        let result = results[indexPath.row]
        cell.firstNameLabel.text = result["First Name"] as? String
        cell.lastNameLabel.text = result["Last Name"] as? String
        cell.reportedTipLabel.text = "\(result["Reported Tip"] ?? "")"
        cell.actualTipLabel.text = "\(result["Actual Tip"] ?? "")"
        let tourTypeIndex = result["Tour Type"] as? Int ?? 0
        cell.tourTypeLabel.text = cell.types[tourTypeIndex]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData(searchText: searchText)
    }

}

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
    let activityIndicator = UIActivityIndicatorView(style: .large)

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        activityIndicator.color = .gray
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if results.isEmpty {
            activityIndicator.startAnimating()
        }
        firebase.loadData(searchText: "") { results in
            self.results = results
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FamilyDetails" {
            if let navigationController = segue.destination as? UINavigationController,
               let detailsViewController = navigationController.viewControllers.first as? FamilyDetailsViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                let selectedData = results[indexPath.row]
                detailsViewController.data = selectedData
            }
        }
    }
    
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
        //let paragraphStyle = NSMutableParagraphStyle()
        //paragraphStyle.headIndent = 20
        cell.firstNameLabel.text = result["First Name"] as? String
//        cell.firstNameLabel.attributedText = NSMutableAttributedString(string: cell.firstNameLabel.text!, attributes: [
//            .paragraphStyle: paragraphStyle
//        ])
        cell.lastNameLabel.text = result["Last Name"] as? String
        cell.easinessLabel.text = result["Easiness"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        firebase.loadData(searchText: searchText) { results in
            self.results = results
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = results[indexPath.row]
        performSegue(withIdentifier: "FamilyDetails", sender: data)
    }

}

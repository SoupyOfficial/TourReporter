//
//  TourSummaryDetailsViewController.swift
//  TipReporter
//
//  Created by Soupy Campbell on 4/29/23.
//

import UIKit
import FirebaseFirestore

class FamilyDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    @IBOutlet weak var interestsTable: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var easinessLabel: UILabel!
    @IBOutlet weak var mainFocusLabel: UILabel!
    @IBOutlet weak var actualTipLabel: UILabel!
    
    @IBOutlet weak var ratingsViewLeft: UIView!
    @IBOutlet weak var ratingsViewRight: UIView!
    
    var selectedSegmentIndex = 0
    @IBOutlet weak var interestsSegment: UISegmentedControl!
    
    var data: [String: Any] = [:]
    var interests: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interestsTable.dataSource = self
        interestsTable.delegate = self
        interestsTable.contentInset = UIEdgeInsets.zero
        
        let font = UIFont.systemFont(ofSize: 21, weight: .medium)
        let selectedTitleTextAttributes = [NSAttributedString.Key.font: font]

        interestsSegment.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        interestsSegment.setTitleTextAttributes(selectedTitleTextAttributes, for: .normal)


        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
                


    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = data["First Name"] as! String + " " + (data["Last Name"] as! String)
        
        // Parse date from timestamp
        let date = (data["Date"] as? Timestamp)!.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d',' yyyy - h:mm a"
        
        dateLabel.text = dateFormatter.string(from: date)
        
        easinessLabel.text = data["Easiness"] as? String
        mainFocusLabel.text = data["Main Focus"] as? String
        
        if let actualTipString = data["Actual Tip"] as? String {
            // Remove ".00" from the end of the string if it exists
            let trimmedString = actualTipString.replacingOccurrences(of: ".00", with: "")
            
            actualTipLabel.text = trimmedString
        }

        interests = (data["Interests"] as? [String])!
        
        //interestsTable.frame = CGRect(x: interestsTable.frame.origin.x, y: interestsTable.frame.origin.y, width: interestsTable.frame.size.width, height: CGFloat(interests.count * 33))

        
        interestsTable.reloadData()
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Calculate the total height of all cells
        var totalHeight: CGFloat = 0
        for section in 0..<interestsTable.numberOfSections {
            for row in 0..<interestsTable.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                totalHeight += interestsTable.rectForRow(at: indexPath).height
            }
        }

        // Adjust the height of the table view
        var tableFrame = interestsTable.frame
        tableFrame.size.height = totalHeight
        interestsTable.frame = tableFrame
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
        guard let interests = data[selectedSegmentIndex == 0 ? "Interests" : "Non-Interests"] as? [String] else {
            return 0
        }
        return interests.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InterestCell", for: indexPath) as! FamilyDetailsCell
        
        if let interests = data[selectedSegmentIndex == 0 ? "Interests" : "Non-Interests"] as? [String], indexPath.row < interests.count {
            cell.title.text = interests[indexPath.row]
        } else {
            cell.title.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    @IBAction func segmentSelectorDidChange(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        interestsTable.reloadData()
    }

}

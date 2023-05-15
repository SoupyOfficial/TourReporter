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
    @IBOutlet weak var ratingsView: UIView!
    
    var selectedSegmentIndex = 0
    @IBOutlet weak var interestsSegment: UISegmentedControl!
    
    var data: [String: Any] = [:]
    var interests: [String] = []
    var popupView = UIView()
    
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
        
        // Temp show ratings button
        //let showRatingsButton = UIBarButtonItem(title: "Show Ratings", style: .plain, target: self, action: #selector(showRatingsButtonTapped))
        //navigationItem.rightBarButtonItem = showRatingsButton
                

        // Ratings Modal
        let ratingsTapGesture = UITapGestureRecognizer(target: self, action: #selector(RatingsViewTapped))
        ratingsTapGesture.numberOfTapsRequired = 1
        ratingsTapGesture.numberOfTouchesRequired = 1

        ratingsView.addGestureRecognizer(ratingsTapGesture)

        
        

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
    
    @objc func RatingsViewTapped() {
        // Create a new UIView for the popup box
        let viewSize = view.bounds.size
        let popupSize = 300
        let popupRadius = popupSize / 2
        popupView = UIView(frame: CGRect(x: (Int(viewSize.width) / 2) - popupRadius, y: (Int(viewSize.height) / 2) - popupRadius, width: popupSize, height: popupSize))
        popupView.backgroundColor = UIColor.systemBackground
        popupView.layer.cornerRadius = 10
        popupView.layer.borderWidth = 1
        popupView.layer.borderColor = UIColor.black.cgColor

        // Add container view to hold labels
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: popupView.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 260),
            containerView.heightAnchor.constraint(equalToConstant: 170)
        ])

        // Add category labels to the container view
        let categories = ["Easiness", "Niceness", "Demandingness", "Follow Directions", "Weird Requests", "Main Focus"]
        for (index, category) in categories.enumerated() {
            let categoryLabel = UILabel()
            categoryLabel.translatesAutoresizingMaskIntoConstraints = false
            categoryLabel.text = category
            categoryLabel.textAlignment = .left
            containerView.addSubview(categoryLabel)

            let dataLabel = UILabel()
            dataLabel.translatesAutoresizingMaskIntoConstraints = false
            dataLabel.text = data[category] as? String ?? ""
            dataLabel.textAlignment = .left
            containerView.addSubview(dataLabel)

            NSLayoutConstraint.activate([
                categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: CGFloat(index * 30)),
                categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                categoryLabel.widthAnchor.constraint(equalToConstant: 140),
                categoryLabel.heightAnchor.constraint(equalToConstant: 20),

                dataLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: CGFloat(index * 30)),
                dataLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 10),
                dataLabel.widthAnchor.constraint(equalToConstant: 70),
                dataLabel.heightAnchor.constraint(equalToConstant: 20),
            ])
        }

        // Add a close button to the popup box
        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        popupView.tag = 1

        popupView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -10),
            closeButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 10),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 20)
        ])

        // Add the popup box to the view hierarchy
        view.addSubview(popupView)

        // Animate the popup box
        popupView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.popupView.alpha = 1
        }
    }




    
    @objc private func showRatingsButtonTapped() {
        // Create a new UIView for the popup box
        let viewSize = view.bounds.size
        let popupSize = 200
        let popupRadius = popupSize / 2
        popupView = UIView(frame: CGRect(x: (Int(viewSize.width) / 2) - popupRadius, y: (Int(viewSize.height) / 2) - popupRadius, width: popupSize, height: popupSize))
        popupView.backgroundColor = UIColor.systemBackground
        popupView.layer.cornerRadius = 10
        popupView.layer.borderWidth = 1
        popupView.layer.borderColor = UIColor.black.cgColor

        // Add a label to the popup box
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world!"
        label.textAlignment = .center
        popupView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: popupView.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 160),
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Add a close button to the popup box
            let closeButton = UIButton(type: .system)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            closeButton.setTitle("Close", for: .normal)
            closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            popupView.tag = 1

            popupView.addSubview(closeButton)
            
            NSLayoutConstraint.activate([
                closeButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -10),
                closeButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 10),
                closeButton.widthAnchor.constraint(equalToConstant: 40),
                closeButton.heightAnchor.constraint(equalToConstant: 20)
            ])

        // Add the popup box to the view hierarchy
        view.addSubview(popupView)


        // Animate the popup box
        popupView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.popupView.alpha = 1
        }
    }
    
    @objc func closeButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.alpha = 0
        }) { _ in
            self.popupView.removeFromSuperview()
        }
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

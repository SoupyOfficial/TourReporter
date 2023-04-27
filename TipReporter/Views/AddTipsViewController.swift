//
//  AddTipsViewController.swift
//  TipReporter
//
//  Created by Soupy Campbell on 4/19/23.
//

import UIKit
import FirebaseFirestore


class AddTipsViewController: UIViewController, UIScrollViewDelegate, InterestsTableViewControllerDelegate {
    
    
    @IBOutlet weak var tourTypesButton: UIButton!
    @IBOutlet weak var tourTypesMenu: UIMenu!

    // input fields
    @IBOutlet weak var tourNotesField: UITextView!
    @IBOutlet weak var tourDateTime: UIDatePicker!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var reportedTipField: UITextField!
    @IBOutlet weak var actualTipField: UITextField!
    @IBOutlet weak var easinessSegment: UISegmentedControl!
    @IBOutlet weak var nicenessSegment: UISegmentedControl!
    @IBOutlet weak var demandingSegment: UISegmentedControl!
    @IBOutlet weak var followDirectionsSegment: UISegmentedControl!
    @IBOutlet weak var weirdRequestsSegment: UISegmentedControl!
    @IBOutlet weak var tourFocusSegment: UISegmentedControl!
    
    
    
    
    var families: [[String: Any]] = []
    let db = Firestore.firestore()

    
    @IBAction func interestsButton(_ sender: Any) {
        let interestsTableViewController = storyboard?.instantiateViewController(withIdentifier: "InterestsTableViewController") as! InterestsTableViewController
           interestsTableViewController.delegate = self
           interestsTableViewController.interestBool = true
           interestsTableViewController.selectedInterests = selectedInterests // Set the initial selection
           interestsTableViewController.selectedRows = selectedInterests.compactMap { interests.firstIndex(of: $0) } // Set the selected rows based on the initial selection
           present(interestsTableViewController, animated: true, completion: nil)
    }
    
    @IBAction func noninterestsButton(_ sender: Any) {
        let interestsTableViewController = storyboard?.instantiateViewController(withIdentifier: "InterestsTableViewController") as! InterestsTableViewController
           interestsTableViewController.delegate = self
           interestsTableViewController.interestBool = false
           interestsTableViewController.selectedInterests = selectedNoninterests // Set the initial selection
           interestsTableViewController.selectedRows = selectedNoninterests.compactMap { interests.firstIndex(of: $0) } // Set the selected rows based on the initial selection
           present(interestsTableViewController, animated: true, completion: nil)
    }
    
    var types = ["Private", "Non-Private", "Educational", "Complementary", "RIP"]
    var selectedTypeIndex = 0 // default to first type
    
    var interestFileContents = try? String(contentsOfFile: "TipReporter/Interests.txt", encoding: .utf8)

    var interests: [String] = []

    var selectedInterests = [String]()

    var selectedNoninterests = [String]()

    // Declare the currency formatter property
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = "$"
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    // Declare the float formatter property
    let floatFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let interestsFileURL = Bundle.main.url(forResource: "Interests", withExtension: "txt") {
            if let interestsFile = try? String(contentsOf: interestsFileURL) {
                interests = interestsFile.components(separatedBy: "\n")
            }
        }
        
        // create the tour types menu
        let tourTypesMenu = UIMenu(title: "Tour Types", children: types.enumerated().map { (index, type) in
            UIAction(title: type, handler: { [weak self] _ in
                self?.selectedTypeIndex = index
                self?.tourTypesButton.setTitle(type, for: .normal)
            })
        })
        
        // assign the menu to the button
        tourTypesButton.menu = tourTypesMenu
        tourTypesButton.showsMenuAsPrimaryAction = true
        tourTypesButton.setTitle(types[selectedTypeIndex], for: .normal)
        
        
        // remove dumb forced extra line
        interests.removeLast()
        // create the interests menu
//        let interestsMenu = UIMenu(title: "Interests", children: interests.enumerated().map { (index, type) in
//            UIAction(title: type, handler: { [weak self] _ in
//                self?.selectedInterestIndex = index
//                self?.interestsButton.setTitle(type, for: .normal)
//            })
//        })
        
        // assign the menu to the button
//        interestsButton.menu = interestsMenu
//        interestsButton.showsMenuAsPrimaryAction = true
//        interestsButton.setTitle(interests[selectedInterestIndex], for: .normal)
//
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print(selectedInterests)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard var text = textField.text else { return }

        // Replace any non-digit characters with an empty string
        text = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)

        // Pad the string with leading zeros if necessary
        let maxLength = 6
        let currentLength = text.count
        if currentLength < maxLength {
            text = String(repeating: "0", count: maxLength - currentLength) + text
        }

        // Convert the string to a double value
        guard let doubleValue = Double(text) else { return }

        // Convert the double value to a decimal value
        let decimalValue = doubleValue / pow(10, Double(currencyFormatter.maximumFractionDigits))

        // Format the decimal value as a currency string
        currencyFormatter.minimumFractionDigits = decimalValue < 1 ? 2 : 0 // add dollar sign if value is less than 1
        textField.text = currencyFormatter.string(from: NSNumber(value: decimalValue))
    }
    
    func interestsTableViewController(_ controller: InterestsTableViewController, didSelectInterests interests: [String], interestsBool: Bool) {
        // Do something with the selected interests here
        print(interestsBool)
        if(interestsBool) {
            selectedInterests = interests
        } else {
            selectedNoninterests = interests
        }
        print("Selected interests: \(interests)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let interestsTableViewController = segue.destination as? InterestsTableViewController {
            interestsTableViewController.delegate = self
        }
    }

    
}

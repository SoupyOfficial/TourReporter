//
//  AddTipsViewController.swift
//  TipReporter
//
//  Created by Soupy Campbell on 4/19/23.
//

import UIKit
import FirebaseFirestore


class AddTipsViewController: UIViewController {
    
    
    @IBOutlet weak var tourTypesButton: UIButton!
    @IBOutlet weak var tourTypesMenu: UIMenu!

    @IBOutlet weak var addFamilyButton: UIButton!
    
    @IBOutlet weak var tourDateTime: UIDatePicker!
    
    var families: [[String: Any]] = []
    let db = Firestore.firestore()

    
    
    var types = ["Private", "Non-Private", "Educational", "Complementary", "RIP"]
    var selectedTypeIndex = 0 // default to first type

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
        // Do any additional setup after loading the view.
        
        // create the menu
                let menu = UIMenu(title: "Tour Types", children: types.enumerated().map { (index, type) in
                    UIAction(title: type, handler: { [weak self] _ in
                        self?.selectedTypeIndex = index
                        self?.tourTypesButton.setTitle(type, for: .normal)
                    })
                })
                
                // assign the menu to the button
                tourTypesButton.menu = menu
                tourTypesButton.showsMenuAsPrimaryAction = true
                tourTypesButton.setTitle(types[selectedTypeIndex], for: .normal)
            }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
        @IBAction func addFamilyButtonPressed(_ sender: Any) {
            let alert = UIAlertController(title: "Add Tip", message: "Enter a name and tip for this tour type", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.autocapitalizationType
                textField.placeholder = "First Name"
            }
            
            alert.addTextField { (textField) in
                textField.autocapitalizationType
                textField.placeholder = "Last Name"
            }
            
            alert.addTextField { (textField) in
                textField.placeholder = "Reported Tip"
                textField.keyboardType = .numberPad
                
                // Apply the currency formatter to the user input
                textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)

            }
            
            alert.addTextField { (textField) in
                textField.placeholder = "Actual Tip"
                textField.keyboardType = .numberPad
                
                // Apply the currency formatter to the user input
                textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] (action) in
                guard let firstName = alert.textFields?[0].text,
                      let lastName = alert.textFields?[1].text,
                      let reportedTip = alert.textFields?[2].text?.replacingOccurrences(of: "$", with: ""),
                      let actualTip = alert.textFields?[3].text?.replacingOccurrences(of: "$", with: ""),
                      !actualTip.isEmpty else { return }
                
                let data: [String: Any] = ["First Name": firstName,
                                           "Last Name": lastName,
                                           "Reported Tip": self?.floatFormatter.number(from: reportedTip) ?? 0,
                                           "Actual Tip": self?.floatFormatter.number(from: actualTip) ?? 0,
                                           "Date": self?.tourDateTime.date,
                                           "Tour Type": self?.selectedTypeIndex]

                // Add a new document with data
                self?.db.collection("Ashley").addDocument(data: data) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added successfully")
                    }
                }
                
                print(self!.families)
            }

            
            alert.addAction(cancelAction)
            alert.addAction(addAction)
            
            present(alert, animated: true, completion: nil)
        }
    
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

}

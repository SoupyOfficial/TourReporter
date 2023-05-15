//
//  AddTipsViewController.swift
//  TipReporter
//
//  Created by Soupy Campbell on 4/19/23.
//

import UIKit


class AddTipsViewController: UIViewController, UIScrollViewDelegate, InterestsTableViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var tourTypesButton: UIButton!
    @IBOutlet weak var tourTypesMenu: UIMenu!
    @IBOutlet weak var resultsMessage: UILabel!
    
    // input fields
    @IBOutlet weak var tourDateTime: UIDatePicker!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var reportedTipLabel: UILabel!
    @IBOutlet weak var reportedTipField: UITextField!
    @IBOutlet weak var actualTipLabel: UILabel!
    @IBOutlet weak var actualTipField: UITextField!
    @IBOutlet weak var easinessSegment: UISegmentedControl!
    @IBOutlet weak var nicenessSegment: UISegmentedControl!
    @IBOutlet weak var demandingSegment: UISegmentedControl!
    @IBOutlet weak var followDirectionsSegment: UISegmentedControl!
    @IBOutlet weak var weirdRequestsSegment: UISegmentedControl!
    @IBOutlet weak var tourFocusSegment: UISegmentedControl!
    @IBOutlet weak var tourNotesField: UITextView!

    var allSegments: [UISegmentedControl] = []
    var originalViewFrame: CGRect?
    var activeTextField: UITextField?
    
    var types = ["Private", "Non-Private", "Educational", "Complementary", "RIP"]
    var selectedTypeIndex = 0 // default to first type
    
    var interestFileContents = try? String(contentsOfFile: "TipReporter/Interests.txt", encoding: .utf8)

    var interests: [String] = []

    var selectedInterests = [String]()
    var selectedNoninterests = [String]()
    
    @IBAction func addFamillyButtonPress(_ sender: Any) {
        // validate required fields
        let requiredFields: [UITextField] = [firstNameField, lastNameField, reportedTipField, actualTipField]
        var emptyFields: [UITextField] = []
        
        for field in requiredFields {
            if field.text?.isEmpty ?? true {
                field.layer.borderWidth = 1.0
                field.layer.borderColor = UIColor.red.cgColor
                emptyFields.append(field)
            } else {
                field.layer.borderWidth = 0.0
            }
        }

        if emptyFields.count > 0 {
            // at least one field is empty, display error message
            resultsMessage.isHidden = false
            resultsMessage.textColor = .red
            resultsMessage.text = "Please fill in all required fields"
            print("Please fill in all required fields")
        } else {
            let data: [String: Any] = ["documentID": UUID().uuidString,
                                       "First Name": firstNameField.text!,
                                       "Last Name": lastNameField.text!,
                                       "Reported Tip": reportedTipField.text!,
                                       "Actual Tip": actualTipField.text!,
                                       "Date": tourDateTime.date,
                                       "Tour Type": types[selectedTypeIndex],
                                       "Easiness": easinessSegment.titleForSegment(at: easinessSegment.selectedSegmentIndex)!,
                                       "Niceness": nicenessSegment.titleForSegment(at: nicenessSegment.selectedSegmentIndex)!,
                                       "Demandingness": demandingSegment.titleForSegment(at: demandingSegment.selectedSegmentIndex)!,
                                       "Follow Directions": followDirectionsSegment.titleForSegment(at: followDirectionsSegment.selectedSegmentIndex)!,
                                       "Weird Requests": weirdRequestsSegment.titleForSegment(at: weirdRequestsSegment.selectedSegmentIndex)!,
                                       "Main Focus": tourFocusSegment.titleForSegment(at: tourFocusSegment.selectedSegmentIndex)!,
                                       "Interests": selectedInterests,
                                       "Non-Interests": selectedNoninterests,
                                       "Tour Notes": tourNotesField.text ?? ""]
            
            
            let firebase = Firebase()
            firebase.addFamily(data: data) { [self] error in
                if let error = error {
                    resultsMessage.isHidden = false
                    resultsMessage.textColor = .red
                    resultsMessage.text = "Error adding family"
                    print("Error adding document: \(error)")
                } else {
                    resultsMessage.isHidden = false
                    resultsMessage.textColor = .green
                    resultsMessage.text = "Family added"
                    print("Document added successfully")
                    
                    // reset fields if successfully added
                    defaultFields()
                }
            }
        }
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func defaultFields() {
        firstNameField.text = ""
        lastNameField.text = ""
        actualTipField.text = "$0.00"
        reportedTipField.text = "$0.00"
        tourDateTime.date = Date()
        selectedTypeIndex = 0
        easinessSegment.selectedSegmentIndex = 2
        nicenessSegment.selectedSegmentIndex = 2
        demandingSegment.selectedSegmentIndex = 2
        followDirectionsSegment.selectedSegmentIndex = 2
        weirdRequestsSegment.selectedSegmentIndex = 2
        tourFocusSegment.selectedSegmentIndex = 2
        selectedInterests = []
        selectedNoninterests = []
        tourNotesField.text = ""
    }
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        
        // Set the delegate of each text field to self
        firstNameField.delegate = self
        lastNameField.delegate = self
        reportedTipField.delegate = self
        actualTipField.delegate = self
        tourNotesField.delegate = self
        
        tapGesture.addTarget(self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
            
        resultsMessage.isHidden = true
        defaultFields()
        
        allSegments = [easinessSegment, nicenessSegment, demandingSegment, tourFocusSegment, weirdRequestsSegment, followDirectionsSegment]
        allSegments.forEach { $0.selectedSegmentIndex = 2 }
        
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
        
        // Apply the currency formatter
        actualTipField.text = "$0.00"
        reportedTipField.text = "$0.00"
        reportedTipField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        actualTipField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)

        
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
    
    // This method is called when the return button on the keyboard is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case firstNameField:
            lastNameField.becomeFirstResponder()
        case lastNameField:
            reportedTipField.becomeFirstResponder()
        case reportedTipField:
            actualTipField.becomeFirstResponder()
        case actualTipField:
            actualTipField.resignFirstResponder()
        case tourNotesField:
            view.endEditing(true)
            tourNotesField.resignFirstResponder()
        default:
            break
        }
        return true
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
        textField.becomeFirstResponder()
        
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
        currencyFormatter.minimumFractionDigits = 2
        var formattedString = currencyFormatter.string(from: NSNumber(value: decimalValue)) ?? ""
        
        // Append extra zeros if necessary
        let decimalCount = formattedString.components(separatedBy: ".").last?.count ?? 0
        if decimalCount < currencyFormatter.minimumFractionDigits {
            formattedString += String(repeating: "0", count: currencyFormatter.minimumFractionDigits - decimalCount)
        }
        
        textField.text = formattedString
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            var rect = self.view.frame
            rect.size.height -= keyboardHeight
            if let activeField = activeTextField, !rect.contains(activeField.frame.origin) {
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let contentInsets = UIEdgeInsets.zero
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            var rect = self.view.frame
            self.view.frame = rect
        }
    }

    @objc func tourNotesTapped() {
        tourNotesField.becomeFirstResponder()
    }
    
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
    
    @objc private func viewTapped() {
        view.endEditing(true)
    }
    
}

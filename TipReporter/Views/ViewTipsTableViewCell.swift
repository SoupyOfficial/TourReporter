//
//  ViewTipsTableViewCell.swift
//  TipReporter
//
//  Created by Soupy Campbell on 4/20/23.
//

import UIKit

class ViewTipsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var reportedTipLabel: UILabel!
    @IBOutlet weak var actualTipLabel: UILabel!
    @IBOutlet weak var tourTypeLabel: UILabel!
    @IBOutlet weak var easinessLabel: UILabel!
    @IBOutlet weak var nicenessLabel: UILabel!
    @IBOutlet weak var demandingLabel: UILabel!
    @IBOutlet weak var linstenedLabel: UILabel!
    @IBOutlet weak var unorthodoxLabel: UILabel!
    @IBOutlet weak var mainFocusLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var nonInterestsLabel: UILabel!
    @IBOutlet weak var tourNotesLabel: UILabel!
    
    
    let formatter = NumberFormatter()
    let types = ["Private", "Non-Private", "Educational", "Complementary", "RIP"]
    
    var tipData: [String: Any]? {
        didSet {
            guard let tipData = tipData else { return }
            
            firstNameLabel.text = tipData["First Name"] as? String ?? ""
            lastNameLabel.text = tipData["Last Name"] as? String ?? ""
            reportedTipLabel.text = tipData["Reported Tip"] as? String ?? ""
            actualTipLabel.text = tipData["Actual Tip"] as? String ?? ""
            tourTypeLabel.text = tipData["Tour Type"] as? String ?? ""
            easinessLabel.text = tipData["Easiness"] as? String ?? ""
            nicenessLabel.text = tipData["Niceness"] as? String ?? ""
            demandingLabel.text = tipData["Demanding"] as? String ?? ""
            linstenedLabel.text = tipData["Listened"] as? String ?? ""
            unorthodoxLabel.text = tipData["Unorthodox"] as? String ?? ""
            mainFocusLabel.text = tipData["Main Focus"] as? String ?? ""
            interestsLabel.text = tipData["Interests"] as? String ?? ""
            nonInterestsLabel.text = tipData["Non-Interests"] as? String ?? ""
            tourNotesLabel.text = tipData["Tour Notes"] as? String ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        formatter.locale = Locale.current
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

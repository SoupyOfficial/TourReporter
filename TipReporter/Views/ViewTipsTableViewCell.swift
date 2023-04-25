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
    
    let formatter = NumberFormatter()
    let types = ["Private", "Non-Private", "Educational", "Complementary", "RIP"]
    
    var tipData: [String: Any]? {
        didSet {
            guard let tipData = tipData,
                  let firstName = tipData["First Name"] as? String,
                  let lastName = tipData["Last Name"] as? String,
                  let reportedTip = tipData["Reported Tip"] as? NSNumber,
                  let actualTip = tipData["Actual Tip"] as? NSNumber,
                  let tourType = tipData["Tour Type"] as? Int
            else { return }
            
            firstNameLabel.text = firstName
            lastNameLabel.text = lastName
            
            formatter.numberStyle = .currency
            reportedTipLabel.text = formatter.string(from: reportedTip)
            actualTipLabel.text = formatter.string(from: actualTip)
            
            tourTypeLabel.text = types[tourType]
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

//
//  ViewTipsTableViewCell.swift
//  TipReporter
//
//  Created by Soupy Campbell on 4/20/23.
//

import UIKit

class ViewTipsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tourDateField: UILabel!
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

//
//  ViewTipsTableViewCell.swift
//  TipReporter
//
//  Created by Soupy Campbell on 4/20/23.
//

import UIKit

class FamilyCell: UITableViewCell {
    
    @IBOutlet weak var tourDateField: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var easinessLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

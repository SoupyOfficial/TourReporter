//
//  RoundedBackgroundView.swift
//  TipReporter
//
//  Created by Soupy Campbell on 5/2/23.
//

import Foundation
import UIKit

class RoundedBackgroundView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 9
        backgroundColor = .separator
    }
}

//
//  Double+Ext.swift
//  VoiceRecorderFinished
//
//  Created by Kishan Arava on 28/8/21.
//  Copyright © 2021 Andreas Schultz. All rights reserved.
//

import Foundation

extension Double {
    func formatDuration() -> String {

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
        formatter.allowedUnits = [.minute, .second] // Units to display in the formatted string
        formatter.zeroFormattingBehavior = [.pad] // Pad with zeroes where appropriate for the locale

        let formattedDuration = formatter.string(from: self)
        
        return formattedDuration!
    }
}

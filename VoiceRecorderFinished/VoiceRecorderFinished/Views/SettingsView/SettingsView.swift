//
//  SettingsView.swift
//  VoiceRecorderFinished
//
//  Created by Kishan Arava on 8/9/21.
//  Copyright © 2021 Andreas Schultz. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var selection: String = "German"
    
    private var languages = [
        "Chinese, Mandarin (Simplified, China)":"zh (cmn-Hans-CN)",
        "English (India)":    "en-IN",
        "English (Singapore)":"en-SG",
        "English (United Kingdom)":    "en-GB",
        "English (United States)":    "en-US",
        "French (France)":    "fr-FR",
        "German (Germany)":    "de-DE",
        "Italian (Italy)":    "it-IT",
        "Japanese (Japan)":    "ja-JP",
        "Portuguese (Brazil)":    "pt-BR",
        "Russian (Russia)":    "ru-RU",
        "Spanish (Spain)":    "es-ES"
    ]
    
    var body: some View {
        Form {
            Section {
                Picker("Languages", selection: $selection) {
                    ForEach(Array(languages.keys), id: \.self) {
                        Text($0)
                    }
                }
            }
        }
        .navigationBarTitle(Text("Settings"))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

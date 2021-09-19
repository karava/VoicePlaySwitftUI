//
//  TextFieldAlert.swift
//  VoiceRecorderFinished
//
//  Created by Kishan Arava on 15/9/21.
//  Copyright © 2021 Andreas Schultz. All rights reserved.
//

import SwiftUI

struct TextFieldAlert: View {
    let title: String
    let message: String?
    let textfieldPlaceholder: String
    let defaultText: String
    let buttonAction: (String) -> Void
    
    @State private var textfieldText = ""
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            
            VStack(alignment: .center) {
                Text(title)
                    .font(.headline)
                
                if let message = message {
                    Text(message)
                        .font(.subheadline)
                }
                
                TextField(textfieldPlaceholder, text: $textfieldText)
                
                Divider()
                
                Button("Update") {
                    buttonAction(textfieldText)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .frame(width: UIScreen.main.bounds.width * 0.7,
                   height: UIScreen.main.bounds.width * 0.7)
            .shadow(radius: 1)
        }
        .onAppear {
            self.textfieldText = defaultText
        }
    }
}

struct TextFieldAlert_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldAlert(title: "alert", message: "Type a name for the audio file", textfieldPlaceholder: "hi", defaultText: "", buttonAction: { str in
            
        })
    }
}

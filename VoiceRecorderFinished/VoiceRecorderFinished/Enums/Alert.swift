//
//  Alert.swift
//  VoiceRecorderFinished
//
//  Created by Kishan Arava on 19/9/21.
//  Copyright © 2021 Andreas Schultz. All rights reserved.
//

import UIKit
import SwiftUI

enum Alert {
    static func titleMessageTextField(title: String?, message: String?, placeholder: String = "", defaultText: String? = nil, saveActionBtnTitle: String, completion: @escaping (_ textFieldText: String) -> Void) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        controller.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = defaultText
        }
        
        let saveAct = UIAlertAction(title: saveActionBtnTitle, style: .default) { _ in
            let textFieldText = controller.textFields![0].text
            
            completion(textFieldText ?? "")
        }
        
        let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        controller.addAction(saveAct)
        controller.addAction(cancelAct)
        
        UIApplication.shared.windows.first?.rootViewController?.present(controller, animated: true, completion: nil)
    }
}

//
//  CocoaAlertController.swift
//  CocoaBaby
//
//  Created by Sohn on 25/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

enum AlertButtonStyle {
    case doneCancel
    case done
    case cancel
}

extension UIAlertController {
    
    convenience init(style: AlertButtonStyle, title: String?, message: String?, doneHandler: ((UIAlertAction) -> Void)?) {
        
        self.init(title: title, message: message, preferredStyle: .alert)
        
        if style == .doneCancel || style == .done {
            let doneAction = UIAlertAction(title: LocalizableString.done, style: .default, handler: doneHandler)
            
            self.addAction(doneAction)
        }
        
        if style == .doneCancel || style == .cancel {
            let cancelAction = UIAlertAction(title: LocalizableString.cancel, style: .cancel, handler: nil)
            
            self.addAction(cancelAction)
        }
    }
}

//
//  Alert.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 07.11.2022.
//

import UIKit

extension UIViewController {
    func yesNoAlert(title: String = "", message: String, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        guard self.presentedViewController as? UIAlertController == nil else { return }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: completionHandler))
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func quickAlert(message: String, completionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
            self.dismiss(animated: true)
            completionHandler?()
        }
    }
}

//
//  UIViewController + Extension.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/11.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

extension UIViewController {
    public func showAlert(_ title: String?, message: String?,
                          confirmTitle: String?, comfireActionHandle: ((UIAlertAction) -> Void)? = nil,
                          cancelTitle: String? = nil, cancelActionHandle: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default, handler: comfireActionHandle)
        if cancelTitle != nil {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: cancelActionHandle)
            alert.addAction(cancelAction)
        }
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
}

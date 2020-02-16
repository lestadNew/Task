//
//  UITextView+Extenshion.swift
//  Task
//
//  Created by Andrey Sokolov on 16.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    /// Setup toolbar with done
    func setupDoneToolbar() {
        var toolbar: UIToolbar?
        toolbar = UIToolbar(frame: CGRect(x: 0,
                                          y: 0,
                                          width: UIScreen.main.bounds.width,
                                          height: 50))
        toolbar?.autoresizingMask = [.flexibleWidth]
        toolbar?.barStyle = UIBarStyle.default
        toolbar?.items = []
        
        toolbar?.items?.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                               target: nil,
                                               action: nil))
        
        let barButton = UIBarButtonItem(title: "Done",
                                        style: UIBarButtonItem.Style.plain,
                                        target: self,
                                        action: #selector(self.done))
        barButton.tintColor = UIColor.black
        
        toolbar?.items?.append(barButton)
        
        toolbar?.sizeToFit()
        inputAccessoryView = toolbar
    }
    
    @objc func done() {
        self.rootSuperview?.endEditing(true)
    }
}

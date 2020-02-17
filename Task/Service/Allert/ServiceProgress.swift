//
//  ShowProgress.swift
//  Task
//
//  Created by Andrey Sokolov on 17.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

struct ServiceProgress {
    
    var data = ActivityData()
    
    func showProgress() {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(data, .none)
    }
    
    func stopProgress() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}

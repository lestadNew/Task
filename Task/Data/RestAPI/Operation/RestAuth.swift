//
//  RestAuth.swift
//  Task
//
//  Created by Andrey Sokolov on 15.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation
import Alamofire

class RestAuth {
    
    /// POST: Exemple login with body
    ///"email": "sample@site.com",
    ///"password": "0123456"
    func auth(withСallName name: String,
              body: [String: Any],
              loader: Bool = true,
              success: @escaping (UserModel) -> ()) {
        
        if loader {
            ServiceProgress().showProgress()
        }
        
        RestCalls().call(model: UserModel.self, path: RestSuffix.Auth.auth.getURL(), method: .post, encoding: JSONEncoding.default, name: name, params: body, headers: nil, success: { (model) in
            KeychainService.standard.token = model
            success(model)
            ServiceProgress().stopProgress()
        }, error: { (error) in
            AlertService().show(title: error.message, message: error.messageError(), action: nil)
            ServiceProgress().stopProgress()
        }) { (error) in
            AlertService().show(title: "Error", message: error.localizedDescription, action: nil)
            ServiceProgress().stopProgress()
        }
    }
    
    
    /// POST: Exemple register with body
    ///"email": "sample@site.com",
    ///"password": "0123456"
    func register(withСallName name: String,
              body: [String: Any],
              loader: Bool = true,
              success: @escaping (UserModel) -> ()) {
        
        if loader {
            ServiceProgress().showProgress()
        }
        
        RestCalls().call(model: UserModel.self, path: RestSuffix.Auth.users.getURL(), method: .post, encoding: JSONEncoding.default, name: name, params: body, headers: nil, success: { (model) in
            KeychainService.standard.token = model
            success(model)
            ServiceProgress().stopProgress()
        }, error: { (error) in
            AlertService().show(title: error.message, message: error.messageError(), action: nil)
            ServiceProgress().stopProgress()
        }) { (error) in
            AlertService().show(title: "Error", message: error.localizedDescription, action: nil)
            ServiceProgress().stopProgress()
        }
    }
}

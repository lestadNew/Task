//
//  RestTask.swift
//  Task
//
//  Created by Andrey Sokolov on 16.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation
import Alamofire

class RestTask {
    func getTask(withСallName name: String,
                 page: Int = 1,
              loader: Bool = false,
              success: @escaping (TaskModel) -> ()) {
        
        RestCalls().call(model: TaskModel.self, path: RestSuffix.Task.getTask.getURL(params: "?page=\(page)"), method: .get, encoding: JSONEncoding.default, name: name, params: nil, headers: RestCalls.authorizationHeader(), success: { (model) in
            success(model)
        }, error: { (error) in
            AlertService().show(title: error.message, message: error.messageError(), action: nil)
        }) { (error) in
            AlertService().show(title: "Error", message: error.localizedDescription, action: nil)
        }
    }
    
    func createTask(withСallName name: String,
                    body: [String: Any]?,
                 page: Int = 1,
              loader: Bool = false,
              success: @escaping (OneTaskModel) -> ()) {
        
        RestCalls().call(model: OneTaskModel.self, path: RestSuffix.Task.getTask.getURL(), method: .post, encoding: JSONEncoding.default, name: name, params: body, headers: RestCalls.authorizationHeader(), success: { (model) in
            success(model)
        }, error: { (error) in
            AlertService().show(title: error.message, message: error.messageError(), action: nil)
        }) { (error) in
            AlertService().show(title: "Error", message: error.localizedDescription, action: nil)
        }
    }
}

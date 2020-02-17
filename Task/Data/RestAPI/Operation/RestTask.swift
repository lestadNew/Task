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
              loader: Bool = true,
              success: @escaping (TaskModel) -> ()) {
        
        if loader {
            ServiceProgress().showProgress()
        }
        
        RestCalls().call(model: TaskModel.self, path: RestSuffix.Task.getTask.getURL(params: "?page=\(page)"), method: .get, encoding: JSONEncoding.default, name: name, params: nil, headers: RestCalls.authorizationHeader(), success: { (model) in
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
    
    func createTask(withСallName name: String,
                    body: [String: Any]?,
              loader: Bool = true,
              success: @escaping (OneTaskModel) -> ()) {
        
        if loader {
            ServiceProgress().showProgress()
        }
        
        RestCalls().call(model: OneTaskModel.self, path: RestSuffix.Task.getTask.getURL(), method: .post, encoding: JSONEncoding.default, name: name, params: body, headers: RestCalls.authorizationHeader(), success: { (model) in
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
    
    func updateTask(withСallName name: String,
                    id: Int,
                    body: [String: Any]?,
              loader: Bool = true,
              success: @escaping () -> ()) {
        
        if loader {
            ServiceProgress().showProgress()
        }
        
        
        RestCalls().call(type: Array<Any>.self, path: RestSuffix.Task.taskWithId(id: id).getURL(), method: .put, encoding: JSONEncoding.default, name: name, params: body, headers: RestCalls.authorizationHeader(), success: { (model) in
            success()
            ServiceProgress().stopProgress()
        }, error: { (error) in
            AlertService().show(title: error.message, message: error.messageError(), action: nil)
            ServiceProgress().stopProgress()
        }) { (error) in
            AlertService().show(title: "Error", message: error.localizedDescription, action: nil)
            ServiceProgress().stopProgress()
        }
    }
    
    func deleteTask(withСallName name: String,
                    id: Int,
              loader: Bool = true,
              success: @escaping () -> ()) {
        
        if loader {
            ServiceProgress().showProgress()
        }
        
        RestCalls().call(type: Array<Any>.self, path: RestSuffix.Task.taskWithId(id: id).getURL(), method: .delete, encoding: JSONEncoding.default, name: name, params: nil, headers: RestCalls.authorizationHeader(), success: { (model) in
            success()
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

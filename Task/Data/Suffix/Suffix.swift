//
//  Suffix.swift
//  Task
//
//  Created by Andrey Sokolov on 15.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation

import Foundation

typealias Suffix = String

struct RestSuffix {
    ///-------------------------------------------------------------------------------------------------------------------------
    struct Auth {
        static var auth: Suffix = "/auth" /// POST Authorize a user by credentials
        static var users: Suffix = "/users" /// POST Create new user expride 24h
    }
    
    struct Task {
        static var getTask: Suffix = "/tasks" /// GET POST Task list
    }
}

//MARK: - Suffix URL
extension Suffix {

    func getBaseUrl() -> String {
        let apiURL = "https://testapi.doitserver.in.ua/api" /// Обычно в плистах , лень делать
        return apiURL
    }

    func getURL(params: String? = nil, isEncoding: Bool = true) -> String {

        var path = getBaseUrl() + self

        if let params = params {
            path += params
        }

        return isEncoding ? path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! : path
    }
}

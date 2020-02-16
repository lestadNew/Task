//
//  File.swift
//  Task
//
//  Created by Andrey Sokolov on 12.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation
import ObjectMapper

class ErrorModel: NSObject, Mappable {
    
    var message: String
    var statusCode: Int?
    var data: Data?
    var fields: FieldsError?
    
    required init?(map: Map) {
        do {
            self.message = try map.value("message")
            self.fields = try? map.value("fields")
        } catch let err {
            debugPrint(err)
            return nil
        }
    }
    func mapping(map: Map) {}
    
    func messageError() -> String? {
        var errorText: [String] = []
        errorText.append(contentsOf: fields?.email ?? [])
        errorText.append(contentsOf: fields?.password ?? [])
        errorText.append(contentsOf: fields?.title ?? [])
        
        let error = errorText.joined(separator: "\n")

        return error
    }
}

class FieldsError: NSObject, Mappable {
    
    var email: [String]?
    var password: [String]?
    var title: [String]?
    
    required init?(map: Map) {
        do {
            self.email = try? map.value("email")
            self.password = try? map.value("password")
            self.title = try? map.value("title")
        } catch let err {
            debugPrint(err)
            return nil
        }
    }
    func mapping(map: Map) {}
}

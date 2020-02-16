//
//  UserModel.swift
//  Task
//
//  Created by Andrey Sokolov on 15.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation
import ObjectMapper

class UserModel: NSObject, Mappable, Codable {
    var token: String
    var expired: Date?
    /// Init
    /// - parameter map: map for parse
    required public init?(map: Map) {
        do {
            self.token = try map.value("token")
            self.expired = Date()
        } catch let err {
            debugPrint(err)
            return nil
        }
    }
    
    /// Mapping model DocumentMapper
    /// - parameter map: map for parse
    public func mapping(map: Map) {}
}

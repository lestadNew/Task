//
//  TaskModel.swift
//  Task
//
//  Created by Andrey Sokolov on 16.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation
import ObjectMapper

class TaskModel: NSObject, Mappable {
    var tasks: [DescriptTaskModel]
    var meta: MetaModel?
    
    /// Init
    /// - parameter map: map for parse
    required public init?(map: Map) {
        do {
            self.tasks = try map.value("tasks")
            self.meta = try map.value("meta")
        } catch let err {
            debugPrint(err)
            return nil
        }
    }
    
    /// Mapping model DocumentMapper
    /// - parameter map: map for parse
    public func mapping(map: Map) {}
}

class DescriptTaskModel: NSObject, Mappable {
    var id: Int
    var title: String
    var dueBy: Date?
    var priority: String?
    /// Init
    /// - parameter map: map for parse
    required public init?(map: Map) {
        do {
            self.id = try map.value("id")
            self.title = try map.value("title")
            self.dueBy = try? Date(seconds: map.value("dueBy"))
            self.priority = try? map.value("priority")
        } catch let err {
            debugPrint(err)
            return nil
        }
    }
    
    /// Mapping model DocumentMapper
    /// - parameter map: map for parse
    public func mapping(map: Map) {}
}

class MetaModel: NSObject, Mappable {
    var current: Int
    var limit: Int
    var count: Int
    
    /// Init
    /// - parameter map: map for parse
    required public init?(map: Map) {
        do {
            self.current = try map.value("current")
            self.limit = try map.value("limit")
            self.count = try map.value("count")
        } catch let err {
            debugPrint(err)
            return nil
        }
    }
    
    /// Mapping model DocumentMapper
    /// - parameter map: map for parse
    public func mapping(map: Map) {}
}

class OneTaskModel: NSObject, Mappable {
    var task: DescriptTaskModel
    
    /// Init
    /// - parameter map: map for parse
    required public init?(map: Map) {
        do {
            self.task = try map.value("task")
        } catch let err {
            debugPrint(err)
            return nil
        }
    }
    
    /// Mapping model DocumentMapper
    /// - parameter map: map for parse
    public func mapping(map: Map) {}
}

//
//  File.swift
//  Task
//
//  Created by Andrey Sokolov on 12.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation
import Alamofire

public enum RestMethod: String {
  case options = "OPTIONS"
  case get     = "GET"
  case head    = "HEAD"
  case post    = "POST"
  case put     = "PUT"
  case patch   = "PATCH"
  case delete  = "DELETE"
  case trace   = "TRACE"
  case connect = "CONNECT"
  
  static func toAlamofile(_ method: RestMethod) -> HTTPMethod {
    
    switch method {
    case options: return HTTPMethod.options
    case get: return HTTPMethod.get
    case head: return HTTPMethod.head
    case post: return HTTPMethod.post
    case put: return HTTPMethod.put
    case patch: return HTTPMethod.patch
    case delete: return HTTPMethod.delete
    case trace: return HTTPMethod.trace
    case connect: return HTTPMethod.connect
    }
    
  }
}

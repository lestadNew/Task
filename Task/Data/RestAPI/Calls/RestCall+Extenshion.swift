//
//  RestCall+Extenshion.swift
//  Task
//
//  Created by Andrey Sokolov on 16.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation

extension RestCalls {
    static func authorizationHeader(token: String? = nil, isDataSended: Bool = false) -> [String: String]? {
          var params: [String: String] = [:]

          /// token - params
          if let token = token {
              params["Authorization"] = "Bearer \(token)"
              return params
          }
          
          /// archive token
          if let token = KeychainService.standard.token?.token  {
              params["Authorization"] = "Bearer \(token)"
          }
          
          /// adding content type for binary data
          if isDataSended {
              params["Content-Type"] = "application/json"
          }
         
          if !params.isEmpty {
              return params
          } else {
              return nil
          }
      }
}


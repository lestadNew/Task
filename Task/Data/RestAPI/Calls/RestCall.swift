//
//  RestCall.swift
//  Task
//
//  Created by Andrey Sokolov on 12.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

struct RestCalls {
    
    // MARK: -
    // MARK: session
    
    static let sessionManager: SessionManager = {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        //        headers["User-Agent"] = Constant.user_agent
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    static var isDebugPrint: Bool = true
    
    //MARK: -
    //MARK: model
    
    func call<T> (type: T.Type,
                    path: String,
                    method: RestMethod,
                    encoding: ParameterEncoding,
                    name: String,
                    params: [String:Any]?,
                    headers: [String:String]?,
                    success:@escaping (_ model: T)->(),
                    error: @escaping (ErrorModel)->(),
                    failure:@escaping (Error)->())  {
        
        let request = RestCalls.sessionManager.request(path,
                                                       method: RestMethod.toAlamofile(method),
                                                       parameters: params,
                                                       encoding: encoding,
                                                       headers: headers)
                                                        .validate(statusCode: 201..<203)
                                                        .responseJSON(completionHandler: { (response) in
                                                        // print
                                                        self.printResponse(response: response, params: params)
                                                        // parsing
                                                        self.parseResponseType(type: type,
                                                                                 response: response,
                                                                                 success: { (result)  in
                                                                                    success(result)
                                                        },
                                                                                 successError: { (model) in
                                                                                    error(model)
                                                        },
                                                                                 failure: { (error) in
                                                                                    failure(error)
                                                        })
                                                       })
        
        
        
        request.task?.taskDescription = name
    }
    
    func call <Model> (model type: Model.Type,
                       path: String,
                       method: RestMethod,
                       encoding: ParameterEncoding,
                       name: String,
                       params: [String:Any]?,
                       headers: [String:String]?,
                       success:@escaping (Model)->(),
                       error: @escaping (ErrorModel)->(),
                       failure:@escaping (Error)->()) where Model: Mappable {
        
        let request = RestCalls.sessionManager.request(path,
                                                       method: RestMethod.toAlamofile(method),
                                                       parameters: params,
                                                       encoding: encoding,
                                                       headers: headers).responseObject(queue: nil, keyPath: nil, mapToObject: nil, context: nil, completionHandler: { (response: DataResponse<Model>) in
                                                        
                                                        
                                                        /// print
                                                        self.printResponse(response: response, params: params)
                                                        /// parsing
                                                        self.parseResponse(response: response, success: { (result) in
                                                            success(result)
                                                        }, successError: { errorModel in
                                                            error(errorModel)
                                                        }, failure: { error in
                                                            failure(error)
                                                        })
                                                       })
        request.task?.taskDescription = name
    }
}


///  Лучше разбить на файлы типа RestCall+Extenshion (RestCall+Pars ...)
//MARK: - print
extension RestCalls {
    
    private func printResponse(response: DataResponse<Any>, params: [String: Any]?) {
        printRequest(request: response.request,
                     data: response.data,
                     params: params)
    }
    
    private func printResponse <T: BaseMappable> (response: DataResponse<T>, params: [String: Any]?) {
        printRequest(request: response.request,
                     data: response.data,
                     params: params)
    }
    
    private func printRequest(request: URLRequest?, data: Data?, params: [String: Any]?) {
        
        if !RestCalls.isDebugPrint { return }
        
        debugPrint("=====================REQUEST=============================")
        debugPrint("send to server:", request?.httpMethod ?? "", request?.url?.absoluteString ?? "<url is nil>")
        debugPrint("headers:", request?.allHTTPHeaderFields ?? "<headers is empty>")
        debugPrint("body:", params ?? "<body is empty>")
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data, options : .allowFragments) {
            debugPrint("data:", json )
        } else {
            debugPrint("data:", "<data is empty>" )
        }
        debugPrint("==========================================================")
    }
}

// MARK: - parsing
extension RestCalls {
    
    func parseResponseType<T> (type: T.Type,
                                 response: DataResponse<Any>,
                                 success:@escaping (_ model: T)->(),
                                 successError: @escaping (ErrorModel)->(),
                                 failure:@escaping (Error)->()) {
        
        switch response.result {
        case .success (let item):
            success(item as! T) /// Не павильное api по рукам надо бить, нельзя превести к протоколу , а по statuscode не дело проверять
        case .failure(let error):
            
            let statusCode = (response.response?.statusCode)
            
            if statusCode == 403 {
                KeychainService.standard.token = nil
                RootRouter.shared.checkRootController()
            } else {
                
                if let data = response.data,
                    let json = String(data: data, encoding: String.Encoding.utf8),
                    let err = convert(inModel: ErrorModel.self, json: json) {
                    err.statusCode = statusCode
                    err.data = data
                    successError(err)
                } else {
                    failure(error)
                }
            }
        }
    }
    
    private func parseResponse <Model:Mappable> (response: DataResponse<Model>,
                                         success:@escaping (Model)->(),
                                         successError: @escaping (ErrorModel)->(),
                                         failure:@escaping (Error)->()) {
        
        switch response.result {
        case .success (let item):
            success(item)
        case .failure(let error):
            
            let statusCode = (response.response?.statusCode)
            
            if statusCode == 403 {
                KeychainService.standard.token = nil
                RootRouter.shared.checkRootController()
            } else {
                
                if let data = response.data,
                    let json = String(data: data, encoding: String.Encoding.utf8),
                    let err = convert(inModel: ErrorModel.self, json: json) {
                    err.statusCode = statusCode
                    err.data = data
                    successError(err)
                } else {
                    failure(error)
                }
            }
        }
    }
}

// MARK: - convert
extension RestCalls {
    
    func convert<Model:Mappable> (inModel type: Model.Type, json: String) -> Model? {
        return Model(JSONString: json)
    }
}

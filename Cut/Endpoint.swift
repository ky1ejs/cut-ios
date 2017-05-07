//
//  Endpoint.swift
//  Cut
//
//  Created by Kyle McAlpine on 22/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct NSURLSessionCompletionHandlerParams {
    let response: URLResponse?
    let data: Data?
    let error: Error?
}

protocol URLResponseDecodeable {
    init(responseParams: NSURLSessionCompletionHandlerParams) throws
}

protocol JSONDecodeable: URLResponseDecodeable {
    associatedtype JsonType
    init(json: JsonType) throws
}

extension JSONDecodeable  {
    init(responseParams: NSURLSessionCompletionHandlerParams) throws {
        guard let data = responseParams.data else { throw ParserError.couldNotParse }
        let json: JsonType = try {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                guard let expectedTypeJson = json as? JsonType else { throw ParserError.invalidJsonType }
                return expectedTypeJson
            } catch let error {
                throw ParserError.invalidJson(error: error)
            }
        }()
        try self.init(json: json)
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

protocol Endpoint {
    associatedtype SuccessData: URLResponseDecodeable
    
    var url: URL { get }
    var urlParams: [String : String] { get }
    var body: [String : Any] { get }
    var headers: [String : String] { get }
    var method: HTTPMethod { get }
}

enum ParserError: Error {
    case couldNotParse
    case invalidJsonType
    case invalidJson(error: Error)
}

struct NoSuccessData: URLResponseDecodeable {
    init() {}
    init(responseParams: NSURLSessionCompletionHandlerParams) throws {}
}

extension Endpoint {
    var urlParams: [String : String] { return [:] }
    var body: [String : Any] { return [:] }
    var headers: [String : String] { return [:] }
    var method: HTTPMethod { return .get }
    
    private var request: URLRequest {
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        comps.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }
        
        var request = URLRequest(url: comps.url!)
        request.httpMethod = method.rawValue
        
        if body.count > 0 {
            request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
            request.allHTTPHeaderFields?["Content-Type"] = "application/json"
        }
        
        if headers.count > 0 {
            headers.forEach() { request.allHTTPHeaderFields?[$0] = $1 }
        }
        request.allHTTPHeaderFields?["device-id"] = UIDevice.current.cutID
        #if DEBUG
            request.allHTTPHeaderFields?["is-dev-device"] = "true"
        #endif
        
        
        print(request.allHTTPHeaderFields)

        return request
    }
    
    func call() -> Observable<SuccessData> {
        return Observable.create { observer in
            
            #if DEBUG
                print(self.request.allHTTPHeaderFields as Any)
                print(self.body)
            #endif
            
            let task = URLSession.shared.dataTask(with: self.request) { (data, response, error) in
                #if DEBUG
                    print(response as Any)
                    print(error)
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) { print(json) }
                #endif
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    observer.on(.error(RxError.unknown))
                    observer.on(.completed)
                    return
                }
                
                do {
                    let params = NSURLSessionCompletionHandlerParams(response: response, data: data, error: error)
                    let data = try SuccessData(responseParams: params)
                    observer.on(.next(data))
                    observer.on(.completed)
                } catch let error {
                    observer.on(.error(error))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

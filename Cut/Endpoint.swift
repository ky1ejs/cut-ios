//
//  Endpoint.swift
//  Cut
//
//  Created by Kyle McAlpine on 22/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol JSONParser {
    associatedtype ParsedType
    associatedtype JsonType
    static func parse(json: JsonType) throws -> ParsedType
}

protocol Endpoint {
    associatedtype Parser: JSONParser
    var url: URL { get }
    var urlParams: [String : String] { get }
}

enum ParserError: Error {
    case couldNotParse
}

extension Endpoint {
    private var request: URLRequest {
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        comps.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }
        return URLRequest(url: comps.url!)
    }
    
    func call() -> Observable<Parser.ParsedType> {
        return Observable.create { observer in
            
            let task = URLSession.shared.dataTask(with: self.request) { (data, response, error) in
                guard let response = response, let data = data else {
                    observer.on(.error(error ?? RxCocoaURLError.unknown))
                    return
                }
                
                guard let string = String(data: data, encoding: .utf8) ?? String(data: data, encoding: .isoLatin1) else {
                    observer.on(.error(RxCocoaURLError.unknown))
                    return
                }
                
                guard let stringData = string.data(using: .utf8) else {
                    observer.on(.error(RxCocoaURLError.unknown))
                    return
                }
            
                do {
                    guard let json = try JSONSerialization.jsonObject(with: stringData, options: []) as? Parser.JsonType else {
                        observer.on(.error(RxCocoaURLError.unknown))
                        return
                    }
                    
                    let model = try Parser.parse(json: json)
                    observer.on(.next(model))
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

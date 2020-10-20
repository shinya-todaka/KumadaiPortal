//
//  APISession.swift
//  kumadai-login
//
//  Created by 戸高新也 on 2020/10/18.
//

import Foundation

class APISession: NSObject {
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum Redirect {
        case follow
        case notfollow
    }
    
    var redirect: Redirect = .follow
    var session: URLSession = .shared
    
    override init() {
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    func call(url: String, method: Method = .get, parameters: [String: String] = [:], headers: [String: String] = [:], redirect: Redirect = .follow, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let url = URL(string: url) else { print("url error "); return }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: url.baseURL != nil) else { print("components error"); return }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        
        switch method {
            case .get:
                components.queryItems = parameters.map { (key, value) in
                    URLQueryItem(name: key, value: value)
                }
                request.url = components.url
            case .post:
                request.httpBody = parameters.percentEncoded()
        }
        
        self.redirect = redirect
        session.dataTask(with: request, completionHandler: completion).resume()
    }
}

extension APISession: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        switch redirect {
        case .follow :
            completionHandler(request)
        case .notfollow:
            completionHandler(nil)
        }
    }
}

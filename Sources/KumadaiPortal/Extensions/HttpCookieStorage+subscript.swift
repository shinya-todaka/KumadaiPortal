//
//  HttpCookieStorage+subscript.swift
//  kumadai-login
//
//  Created by 戸高新也 on 2020/10/17.
//

import Foundation

extension HTTPCookieStorage {
    public subscript(domain domain: String,path path: String, name name: String) -> HTTPCookie?{
        guard let cookies = Self.shared.cookies else {
            return nil
        }
        
        return cookies.filter { $0.domain == domain && $0.path == path && $0.name == name }.first
    }
}

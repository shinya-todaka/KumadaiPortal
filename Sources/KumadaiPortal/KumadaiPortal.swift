//
//  KumadaiPortal.swift
//  kumadai-login
//
//  Created by 戸高新也 on 2020/10/17.
//

import Foundation
import Kanna

class KumadaiPortal: NSObject {
    
    static let shared = KumadaiPortal()
    
    private let session = APISession()
    
    private override init() {}
    
    func login(username: String, password: String, completion: @escaping (PortalError?) -> Void) {
        self.getIdpJsessionId() { (error) in
            if let error = error {
                print(error)
                completion(.unknownError)
            }
            
            self.getShibIdpSession(username: username, password: password, completion: { (relayState, samlResponse, error) in
                if let error = error{
                    print(error)
                    completion(.unknownError)
                }
                
                guard let relayState = relayState, let samlResponse = samlResponse else {
                    completion(.invalidPasswordOrUsername)
                    return
                }
                
                self.getShibSession(relayState: relayState, samlResponse: samlResponse, completion: { (error) in
                    if let error = error {
                        print(error)
                        completion(.unknownError)
                    }
                    
                    self.getJSessionIdFromShibSession(completion: { (parameters, error) in
                        if let error = error {
                            print(error)
                            completion(.unknownError)
                        }
                        
                        guard let parameters = parameters else { return }
                        
                        self.getCASTGC(parameters: parameters) { (error) in
                            if let error = error {
                                print(error)
                                completion(.unknownError)
                            }
                            completion(nil)
                        }
                    })
                })
            })
        }
    }
    
    func getTimeTable(completion: @escaping (CourseResponse?, Error?) -> Void) {
        self.getJsesionIDForTimeTable() { error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            self._getTimeTable(completion: { (courseResponse, error) in
                completion(courseResponse, error)
            })
        }
    }
    
    func getSeiseki(completion: @escaping ([Grade]?, Error?) -> Void) {
        let url = "https://kuss.kumamoto-u.ac.jp/ssk00.php"
        let parameters = ["lang": "ja"]
        session.call(url: url, parameters: parameters) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("data is nil")
                return
            }
            
            guard let html = try? HTML(html: data, encoding: .utf8) else {
                print("cant encode html")
                completion(nil, nil)
                return
            }
            
            guard let seiseki = html.css("tbody[class='seiseki']").first else {
                print("cant find seiseki")
                completion(nil, nil)
                return
            }
            
            guard let inner = seiseki.innerHTML else {
                print("cant find inner")
                completion(nil, nil)
                return
            }
            
            let innerHtml = try! HTML(html: inner, encoding: .utf8)
            
            let trs = innerHtml.css("tr").dropFirst()
            
            let grades = trs.compactMap { (tr) -> Grade? in
                let tds = tr.css("td")
                
                let optionalProperties = tds.map { (element) -> String? in
                    return element.content
                }
                
                guard let properties: [String] = (optionalProperties.contains(nil) ? nil : optionalProperties.compactMap{$0}) else {
                    return nil
                }
                
                if properties.count != 6 {
                    return nil
                }
                
                let grade = Grade(no: properties.first!, subjectName: properties[1], unitCount: properties[2], yearAndSemester: properties[3], evaluation: properties[4], result: properties[5])
                
                return grade
            }
            
            completion(grades, nil)
        }
    }
     
    // just to save cookie
    private func getIdpJsessionId(completion: @escaping (Error?) -> Void) {
        let url = "https://cas.kumamoto-u.ac.jp/cas/login"
        
        session.call(url: url) { (_, _, error) in
            if let error = error {
                print(error)
                completion(error)
            }
            completion(nil)
        }
    }
    
    private func getShibIdpSession(username: String, password: String, completion: @escaping (String?, String?, Error?) -> Void) {
        guard let jsessionId = HTTPCookieStorage.shared[domain: "shib.kumamoto-u.ac.jp",path: "/idp",name: "JSESSIONID"] else { return }
        let url = "https://shib.kumamoto-u.ac.jp/idp/profile/SAML2/Redirect/SSO;jsessionid=\(jsessionId.value)?execution=e1s1"
        
        let language = "ja"
        let parameters: [String: String] = ["j_username": username, "j_password": password, "language": language, "_eventId_proceed": ""]
        
        session.call(url: url, method: .post, parameters: parameters) { (data, _, error) in
            if let error = error {
                print(error)
                completion(nil, nil, error)
                return
            }
            
            guard let data = data, let html = try? HTML(html: data, encoding: .utf8) else { return }
            
            guard let relayState = html.css("input[name='RelayState']").first?["value"] else {
                completion(nil, nil, nil)
                return
            }
            
            guard let samlResponse = html.css("input[name='SAMLResponse']").first?["value"] else {
                completion(nil,nil,nil)
                return
            }

            completion(relayState, samlResponse, nil)
        }
    }
    
    // just to save cookie
    private func getShibSession(relayState: String, samlResponse: String, completion: @escaping (Error?) -> Void){
        let url = "https://cas.kumamoto-u.ac.jp/cas/shib/common/Shibboleth.sso/SAML2/POST"
        let parameters: [String: String] = ["RelayState": relayState, "SAMLResponse": samlResponse]
        
        session.call(url: url, method: .post, parameters: parameters, redirect: .notfollow) { (data, response, error) in
            if let error = error {
                print(error)
                completion(error)
            }

            completion(nil)
        }
    }
    
    private func getJSessionIdFromShibSession(completion: @escaping ([String: String]?, Error?) -> Void) {
        let url = "https://cas.kumamoto-u.ac.jp/cas/login"
        let parameters = ["service": "https://uportal.kumamoto-u.ac.jp/uPortal/LoginTF"]

        session.call(url: url, parameters: parameters) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else { return }
            guard let html = try? HTML(html: data, encoding: .utf8) else { return }

            let username = html.css("input[name='username']").first!["value"]!
            let lt = html.css("input[name='lt']").first!["value"]!
            let execution = html.css("input[name='execution']").first!["value"]!
            let _eventId = html.css("input[name='_eventId']").first!["value"]!
            let submit = "ログイン"

            let parameters = ["username": username, "lt": lt, "execution": execution, "_eventId": _eventId, "submit": submit]

            completion(parameters, nil)
        }
    }
     
    // just to save cookie
    private func getCASTGC(parameters: [String: String], completion: @escaping (Error?) -> Void) {
        guard let jSessionID = HTTPCookieStorage.shared[domain: "shib.kumamoto-u.ac.jp",path: "/idp",name: "JSESSIONID"] else { return }
        let url = "https://cas.kumamoto-u.ac.jp/cas/shib/common/login;jsessionid=\(jSessionID.value)?service=https://uportal.kumamoto-u.ac.jp/uPortal/LoginTF"
    
        session.call(url: url, parameters: parameters) { (_, _, error) in
            if let error = error {
                print(error)
                completion(error)
            }
            completion(nil)
        }
    }
    
    // just to save cookie
    private func getJsesionIDForTimeTable(completion: @escaping (Error?) -> Void) {
        let url = "https://cas.kumamoto-u.ac.jp/cas/login"
        let parameters = ["service": "http://lecregdb.kumamoto-u.ac.jp/ttapi/rest/open/state2.json?callback=callbackFunc"]
        
        session.call(url: url, parameters: parameters) { (_, _, error) in
            if let error = error {
                print(error)
                completion(error)
            }
            completion(nil)
        }
    }
    
    private func _getTimeTable(completion: @escaping (CourseResponse?, Error?) -> Void) {
        let url = "http://lecregdb.kumamoto-u.ac.jp/ttapi/rest/open/timetable.json"
        let parameters = ["callback": "", "locale": "ja", "_": "1"]
        
        session.call(url: url, parameters: parameters,redirect: .notfollow) { (data, response, error) in
            guard let data = data else { return }
            let string = String(data: data, encoding: .utf8)!
            let jsonString = string.dropFirst().dropLast().dropLast()
            let jsonData = jsonString.data(using: .utf8)!
            
            do {
                let coursesResponse = try JSONDecoder().decode(CourseResponse.self, from: jsonData)
                completion(coursesResponse, nil)
            } catch let error {
                print("cant decode timetable!!!!!: \(error)")
                completion(nil, error)
            }
        }
    }
}

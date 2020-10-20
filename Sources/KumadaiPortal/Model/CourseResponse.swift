//
//  CourseResponse.swift
//  kumadai-login
//
//  Created by 戸高新也 on 2020/10/19.
//

import Foundation

struct CourseResponse: Decodable {
    let sakaiUri: String
    let moodleUri: String
    let uid: String
    let affiliation: Int
    let lastname: String
    let sakaiNum: Int
    let firstname: String
    let syllabusAuthUri: String
    let stid: String
    let ip: String
    let maharaNum: Int
    let callback: String
    let syllabusOldUri: String
    let maharaUri : String
    let moodleNum: Int
    let syllabusModYear: Int
    let courses: Courses
}

struct Courses: Decodable {
    let _2014: Semester?
    let _2015: Semester?
    let _2016: Semester?
    let _2017: Semester?
    let _2018: Semester?
    let _2019: Semester?
    let _2020: Semester?
    
    enum CodingKeys: String, CodingKey {
        case _2014 = "2014"
        case _2015 = "2015"
        case _2016 = "2016"
        case _2017 = "2017"
        case _2018 = "2018"
        case _2019 = "2019"
        case _2020 = "2020"
    }
}

struct Semester: Decodable {
    let first: DayOfWeek?
    let second: DayOfWeek?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case first = "1"
        case second = "2"
    }
}

struct DayOfWeek: Decodable {
     let mon: Period?
     let tue: Period?
     let wed: Period?
     let thu: Period?
     let fri: Period?
     
     enum CodingKeys: String, CodingKey, CaseIterable {
         case mon = "1"
         case tue = "2"
         case wed = "3"
         case thu = "4"
         case fri = "5"
     }
 }

struct Period: Decodable {
    let first: [Course]?
    let second: [Course]?
    let third: [Course]?
    let fourth: [Course]?
    let fifth: [Course]?
    let sixth: [Course]?
    let seventh: [Course]?
    
    enum CodingKeys: String, CodingKey {
        case first = "1"
        case second = "2"
        case third = "3"
        case fourth = "4"
        case fifth = "5"
        case sixth = "6"
        case seventh = "7"
    }
}

struct Course: Decodable {
    let courseId: String
    let name: String
    let lms: Int
}

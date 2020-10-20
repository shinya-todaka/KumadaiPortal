//
//  CourseResponse.swift
//  kumadai-login
//
//  Created by 戸高新也 on 2020/10/19.
//

public struct CourseResponse: Decodable {
    public let sakaiUri: String
    public let moodleUri: String
    public let uid: String
    public let affiliation: Int
    public let lastname: String
    public let sakaiNum: Int
    public let firstname: String
    public let syllabusAuthUri: String
    public let stid: String
    public let ip: String
    public let maharaNum: Int
    public let callback: String
    public let syllabusOldUri: String
    public let maharaUri : String
    public let moodleNum: Int
    public let syllabusModYear: Int
    public let courses: Courses
}

public struct Courses: Decodable {
    public let _2014: Semester?
    public let _2015: Semester?
    public let _2016: Semester?
    public let _2017: Semester?
    public let _2018: Semester?
    public let _2019: Semester?
    public let _2020: Semester?
    
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

public struct Semester: Decodable {
    public let first: DayOfWeek?
    public let second: DayOfWeek?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case first = "1"
        case second = "2"
    }
}

public struct DayOfWeek: Decodable {
     public let mon: Period?
     public let tue: Period?
     public let wed: Period?
     public let thu: Period?
     public let fri: Period?
     
     enum CodingKeys: String, CodingKey, CaseIterable {
         case mon = "1"
         case tue = "2"
         case wed = "3"
         case thu = "4"
         case fri = "5"
     }
 }

public struct Period: Decodable {
    public let first: [Course]?
    public let second: [Course]?
    public let third: [Course]?
    public let fourth: [Course]?
    public let fifth: [Course]?
    public let sixth: [Course]?
    public let seventh: [Course]?
    
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

public struct Course: Decodable {
    public let courseId: String
    public let name: String
    public let lms: Int
}

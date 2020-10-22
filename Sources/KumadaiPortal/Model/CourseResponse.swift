//
//  CourseResponse.swift
//  kumadai-login
//
//  Created by 戸高新也 on 2020/10/19.
//

public struct TimeTableResponse: Decodable {
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
    public let _2014: Year?
    public let _2015: Year?
    public let _2016: Year?
    public let _2017: Year?
    public let _2018: Year?
    public let _2019: Year?
    public let _2020: Year?
    
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

public struct Year: Decodable {
    public var first: Semester?
    public var second: Semester?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case first = "1"
        case second = "2"
    }
    
    public init(from decoder: Decoder) throws  {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let week = try container.decodeIfPresent(Week.self, forKey: .first) {
            self.first = Semester(week: week)
        }
        
        if let week = try container.decodeIfPresent(Week.self, forKey: .second) {
            self.second = Semester(week: week)
        }
    }
}

public struct Week: Decodable {
    public let mon: Day?
    public let tue: Day?
    public let wed: Day?
    public let thu: Day?
    public let fri: Day?
    
    enum CodingKeys: String, CodingKey {
        case mon = "1"
        case tue = "2"
        case wed = "3"
        case thu = "4"
        case fri = "5"
    }
}

public struct Semester: Decodable {
    public let week: Week
    
    enum CodingKeys: String, CodingKey {
        case week
    }
    
    public var timetable: [[Period?]?] {
        return [week.mon, week.tue, week.wed, week.thu, week.fri].map { $0?.periods }
    }
}

public struct Day: Decodable {
    public var first: Period?
    public var second: Period?
    public var third: Period?
    public var fourth: Period?
    public var fifth: Period?
    public var sixth: Period?
    public var seventh: Period?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case first = "1"
        case second = "2"
        case third = "3"
        case fourth = "4"
        case fifth = "5"
        case sixth = "6"
        case seventh = "7"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let courses = try container.decodeIfPresent([Course].self, forKey: .first) {
            self.first = Period(courses: courses)
        }
        
        if let courses = try container.decodeIfPresent([Course].self, forKey: .second) {
            self.second = Period(courses: courses)
        }
        
        if let courses = try container.decodeIfPresent([Course].self, forKey: .third) {
            self.third = Period(courses: courses)
        }
        
        if let courses = try container.decodeIfPresent([Course].self, forKey: .fourth) {
            self.fourth = Period(courses: courses)
        }
        
        if let courses = try container.decodeIfPresent([Course].self, forKey: .fifth) {
            self.fifth = Period(courses: courses)
        }
        
        if let courses = try container.decodeIfPresent([Course].self, forKey: .sixth) {
            self.sixth = Period(courses: courses)
        }
    }
    
    public var periods: [Period?] {
        return [first, second, third, fourth, fifth, sixth, seventh]
    }
}

public struct Period: Decodable {
    let courses: [Course]
}

public struct Course: Decodable {
    public let courseId: String
    public let name: String
    public let lms: Int
}

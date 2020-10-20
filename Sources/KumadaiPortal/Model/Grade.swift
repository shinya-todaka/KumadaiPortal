//
//  Grade.swift
//  kumadai-login
//
//  Created by 戸高新也 on 2020/10/19.
//

public struct Grade {
    public let no: Int
    public let subjectName: String
    public let unitCount: Int
    public let yearAndSemester: String
    public let evaluation: Evaluation
    public let result: Bool
    
    public enum Evaluation: String {
        case excellent = "優"
        case good = "良"
        case passing = "可"
        case failing = "不可"
    }
    
    public init?(no: String, subjectName: String, unitCount: String, yearAndSemester: String, evaluation: String, result: String) {
        guard let no = Int(no) else {
            return nil
        }
        
        guard let unitCount = Int(unitCount) else {
            return nil
        }
        
        guard let evaluation = Evaluation(rawValue: evaluation) else {
            return nil
        }
        
        self.no = no
        self.subjectName = subjectName
        self.unitCount = unitCount
        self.yearAndSemester = yearAndSemester
        self.evaluation = evaluation
        if result == "合" {
            self.result = true
        } else if result == "否" {
            self.result = false
        } else {
            return nil 
        }
    }
}



//
//  Subjects.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 3.09.24.
//

import Foundation

enum Subjects: CaseIterable {
    case math
    case chemistry
    case grammar
    case physics
    case biology
    case litSummary
    case result
    
    var title: String {
        switch self {
        case .math:
            "Mathematics task"
        case .chemistry:
            "Chemistry task"
        case .grammar:
            "Grammar check"
        case .physics:
            "Physics task"
        case .biology:
            "Biology task"
        case .litSummary:
            "Literary Summary"
        case .result:
            "Results"
        }
    }
    
    static func getSubject(title: String) -> Subjects? {
        return Subjects.allCases.first(where: { $0.title == title })
    }
    
}

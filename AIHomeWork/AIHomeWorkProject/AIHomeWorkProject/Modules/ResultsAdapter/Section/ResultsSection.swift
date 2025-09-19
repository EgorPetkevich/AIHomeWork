//
//  ResultsSection.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 11.09.24.
//

import UIKit

enum ResultsSection: ResultsHeaderProtocol {
    case task(TaskSection)
    case solution(SolutionSection)
    case result(ResultSection)
    
    var numberOfRows: Int {
        return 1
    }
    
    var titleHeader: String {
        switch self {
        case .task(_):
            return "Task"
        case .solution(_):
            return "Solution"
        case .result(_):
            return "Result"
        }
    }
    
    var iconImage: UIImage {
        switch self {
        case .task(_):
            return .AppIcon.taskImage
        case .solution(_):
            return .AppIcon.solutionImage
        case .result(_):
            return .AppIcon.solutionImage
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .task(_):
            return .appDarkGray
        case .solution(_):
            return .appLightBlue
        case .result(_):
            return .appLightBlue
        }
    }
    
    var showCopieButton: Bool {
        switch self {
        case .task(let taskSection):
            return false
        default:
            return true
        }
    }
    
}

enum TaskSection: CaseIterable, ResultsCellProtocol {

    case taskRow
    
    var backgroundColor: UIColor {
        return .appDarkGray
    }
    
    var showCopieButton: Bool {
        return false
    }
   
}

enum SolutionSection: CaseIterable, ResultsCellProtocol {
    
    case solutionRow
    
    var backgroundColor: UIColor {
        return .appLightBlue
    }
    
    var showCopieButton: Bool {
        return true
    }
   
}

enum ResultSection: CaseIterable, ResultsCellProtocol {
    
    case resultRow
    
    var backgroundColor: UIColor {
        return .appLightBlue
    }
    
    var showCopieButton: Bool {
        return true
    }
   
}

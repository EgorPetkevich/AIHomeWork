//
//  HomeSections.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 1.09.24.
//

import UIKit

enum HomeSections {
    case first([FirstSectionRows])
    case second([SecondSectionRows])
    
    var numberOfRows: Int {
        switch self {
        case .first(let rows): return rows.count
        case .second(let rows): return rows.count
        }
    }
}

enum FirstSectionRows: CaseIterable, HomeCellSetupProtocol {
    case math
    case chemistry
    case grammar
    
    var image: UIImage {
        switch self {
        case .math: return .MainApp.Home.Adapter.chalkboardImage
        case .chemistry: return .MainApp.Home.Adapter.chemistyImage
        case .grammar: return .MainApp.Home.Adapter.notebookImage
        }
    }
    
    var title: String {
        switch self {
        case .math: return "Math"
        case .chemistry: return "Chemistry"
        case .grammar: return "Grammar\ncheck"
        }
    }
}

enum SecondSectionRows: CaseIterable, HomeCellSetupProtocol {
    case physics
    case biology
    case litSummary
    
    var image: UIImage {
        switch self {
        case .physics: return .MainApp.Home.Adapter.atomImage
        case .biology: return .MainApp.Home.Adapter.dnkImage
        case .litSummary: return .MainApp.Home.Adapter.booksImage
        }
    }
    
    var title: String {
        switch self {
        case .physics: return "Physics"
        case .biology: return "Biology"
        case .litSummary: return "Literary\nSummary"
        }
    }
}

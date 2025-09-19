//
//  ResultsMenuBuilder.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 10.09.24.
//

import UIKit

final class ResultsMenuBuilder {
    
    private init() {}
    
    static func build(delegate: ResultsMenuDelegate,
                      sourceView: UIView) -> UIViewController {
        let adapter = ResultsMenuAdapter(actions: [.edit, .askExpert, .delete])
        let menu = ResultsMenuVC(adapter: adapter,
                                 delegate: delegate,
                                 sourceView: sourceView)
        menu.popoverPresentationController?.permittedArrowDirections =
        UIPopoverArrowDirection(rawValue:0)
        return menu
    }
    
    static func buildSolvedTask(delegate: ResultsMenuDelegate, 
                      sourceView: UIView) -> UIViewController {
        let adapter = ResultsMenuAdapter(actions: [.edit, .delete])
        let menu = ResultsMenuVC(adapter: adapter,
                                 delegate: delegate,
                                 sourceView: sourceView)
        menu.popoverPresentationController?.permittedArrowDirections =
        UIPopoverArrowDirection(rawValue:0)
        return menu
    }
    
    static func buildChat(delegate: ResultsMenuDelegate,
                          sourceView: UIView) -> UIViewController {
        let adapter = ResultsMenuAdapter(actions: [.rename, .delete])
        let menu = ResultsMenuVC(adapter: adapter,
                                 delegate: delegate,
                                 sourceView: sourceView)
        menu.popoverPresentationController?.permittedArrowDirections =
        UIPopoverArrowDirection(rawValue:0)
        return menu
    }
    
}

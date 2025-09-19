//
//  RemoteConfig.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.09.24.
//

import Foundation

///
///{
///"closeTimer": 1,
///"review": true,
///"supportTrial": false
///}

struct RemoteConfig: Codable {
    let closeTimer: Int
    let review: Bool
    let supportTrial: Bool
    
}

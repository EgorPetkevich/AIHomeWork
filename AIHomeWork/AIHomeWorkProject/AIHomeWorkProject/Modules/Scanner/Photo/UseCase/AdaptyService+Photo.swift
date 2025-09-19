//
//  AdaptyService+Photo.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 13.11.24.
//

import Foundation

struct PhotoAdaptyServiceUseCase: PhotoAdaptyServiceUseCaseProtocol {
    
    var isPremium: Bool
    var remoteConfig: RemoteConfig?
    
    init(service: AdaptyService) {
        self.isPremium = service.isPremium
        self.remoteConfig = service.remoteConfig
    }
    
}

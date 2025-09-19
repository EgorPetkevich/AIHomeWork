//
//  FileManager+Chat.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 19.09.24.
//

import Foundation
import UIKit

struct AIExpertChatFileManagerServiceUseCase:
    AIExpertChatFileManagerServiceUseCaseProtocol {
    
    private let manager: FileManagerService
    
    init(manager: FileManagerService) {
        self.manager = manager
    }
    
    func saveImage(image: UIImage,
                   with path: String,
                   completion: CompletionHandler?) {
        self.manager.save(directory: .TaskImages, 
                          image: image, with: path,
                          completion: completion)
    }
    
    func delete(with path: String) {
        self.manager.delete(directory: .TaskImages,
                            with: path,
                            completion: nil)
    }
    
}

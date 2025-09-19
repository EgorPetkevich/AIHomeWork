//
//  PhotoAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 8.09.24.
//

import UIKit

final class PhotoAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: PhotoCoordinatorProtocol,
                     image: UIImage, completion: ((UIImage) -> Void)?
    ) -> PhotoVC {
        let adaptyService =
        PhotoAdaptyServiceUseCase(service: container.resolve())
        let photoVM = PhotoVM(coordinator: coordinator,
                              completion: completion,
                              adaptyService: adaptyService)
        let photoVC = PhotoVC(viewModel: photoVM, image: image)
        return photoVC
    }
}

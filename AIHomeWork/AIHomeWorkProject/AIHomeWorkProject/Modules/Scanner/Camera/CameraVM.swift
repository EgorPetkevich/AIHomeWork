//
//  CameraVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 5.09.24.
//

import UIKit
import Photos
import AVFoundation

enum FlashlightMode {
    case on
    case off
}

protocol CameraCoordinatorProtocol: AnyObject {
    func showImagePicker(delegate: any UIImagePickerControllerDelegate &
                                       UINavigationControllerDelegate)
    func openPhoto(image: UIImage)
    func finish()
}

protocol CameraAlertServiceUseCaseProtocol {
    func hideAlert()
    func showCameraError(title: String,
                         message: String,
                         goSettings: String,
                         goSettingsHandler: @escaping () -> Void)
}

final class CameraVM: NSObject {
    
    var lastImageFromGallery: ((UIImage?) -> Void)?
    var toggleFlashlight: ((FlashlightMode) -> Void)?
    
    weak var coordinator: CameraCoordinatorProtocol?
    
    private let captureSessionQueue: DispatchQueue =
        .init(label: "com.camera.startrunning",
              qos: .background,
              attributes: .concurrent)
    
    private let requestAccessQueue: DispatchQueue =
        .init(label: "com.camera.requestaccess",
              qos: .default,
              attributes: .concurrent)
    
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    private var alertServise: CameraAlertServiceUseCaseProtocol
    private var metadataOutput = AVCaptureMetadataOutput()
    private var captureSession = AVCaptureSession()
    private var flashSettings = AVCapturePhotoSettings()
    var stillImageOutput = AVCapturePhotoOutput()
    private let videoCaptureDevice: AVCaptureDevice? = AVCaptureDevice
        .default(.builtInWideAngleCamera, for: .video, position: .back)
    
    init(coordinator: CameraCoordinatorProtocol,
         alertService: CameraAlertServiceUseCaseProtocol) {
        self.coordinator = coordinator
        self.alertServise = alertService
    }
    
}

extension CameraVM: CameraViewModelProtocol {
    
    func backButtonDidTap() {
        coordinator?.finish()
    }
    
    func openGalleryButtonDidTap() {
        openGallery()
    }
    
    func captureButtonDidTap() {
        takePhoto()
    }
    
    
    func flashlightButtonDidTap() {
        guard let videoCaptureDevice else { return }
        
        if videoCaptureDevice.isTorchActive {
            toggleFlashlight(with: .off)
        } else {
            toggleFlashlight(with: .on)
        }
    }
    
    //hand over previewLayer to VC
    func getCameraPreview() -> AVCaptureVideoPreviewLayer? {
        createVideoInput()
        
        let previewLayer =
        AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        return previewLayer
    }
    
}

//MARK: - Lifecycles Methods from VC
extension CameraVM {
    
    func viewWillAppear() {
        let not = NotificationCenter.default
        not.addObserver(self, selector: #selector(viewWillResignActive),
                        name: UIApplication.willResignActiveNotification,
                        object: nil)
        checkForPermissions()
        requestPhotoLibraryAccess()
    }
    
    func viewDidDisappear() {
        toggleFlashlight(with: FlashlightMode.off)
        alertServise.hideAlert()
        stopRunning()
    }
    
    @objc func viewWillResignActive() {
        toggleFlashlight(with: FlashlightMode.off)
        alertServise.hideAlert()
    }
    
}

//MARK: - Camera Setup
extension CameraVM {
    
    //check permission to show camera
    private func checkForPermissions() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            startRunning()
            break
        case .notDetermined:
            /*
             Suspend the session queue to delay session
             until the access request has completed.
             */
            requestAccessQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video,
                                          completionHandler: { granted in
                if !granted {
                    self.showCameraErrorAlert()
                } else {
                    self.startRunning()
                }
                self.requestAccessQueue.resume()
            })
        default: showCameraErrorAlert()
        }
    }
    
    //start captureSession
    private func startRunning() {
        captureSessionQueue.async { [captureSession] in
            captureSession.startRunning()
        }
    }
    
    //stop captureSession/
    private func stopRunning() {
        captureSessionQueue.async { [captureSession] in
            captureSession.stopRunning()
        }
    }
    
}

//MARK: - Setup camera: [VideoInput, PhotoOutput]
extension CameraVM: AVCapturePhotoCaptureDelegate {
    
    private func createVideoInput() {
        guard let videoCaptureDevice else { return }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        if (captureSession.canAddInput(videoInput)){
            captureSession.addInput(videoInput)
        } else {
            return
        }
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, 
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard
            let imageData = photo.fileDataRepresentation(),
            let image = UIImage(data: imageData)
        else { return }
        
        let croppedImage = 
        cropImageToCamaraLayerRelativeToScreen(originalImage: image)
        guard let croppedImage else { return }
        coordinator?.openPhoto(image: croppedImage)
    }
    
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        guard
            let photoOutputConnection = 
                stillImageOutput.connection(with: .video)
        else {
            return
        }
        photoOutputConnection.videoOrientation = .portrait
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
}

extension CameraVM {
    
    func cropImageToCamaraLayerRelativeToScreen(
        originalImage: UIImage
    ) -> UIImage? {
        guard let previewLayer = previewLayer else { return nil }
        
        let screenSize = UIScreen.main.bounds.size
        let imageSize = originalImage.size
        
        let scaleX = imageSize.width / screenSize.width
        let scaleY = imageSize.height / screenSize.height
        
        let camaraLayerFrameOnScreen = 
        previewLayer.superlayer?.convert(previewLayer.frame, to: nil) ?? .zero
        
        let scaledCropRect = CGRect(
            x: camaraLayerFrameOnScreen.origin.x * scaleX,
            y: camaraLayerFrameOnScreen.origin.y * scaleY,
            width: camaraLayerFrameOnScreen.size.width * scaleX,
            height: camaraLayerFrameOnScreen.size.height * scaleY
        )
        
        guard 
            let croppedCGImage = 
                originalImage.cgImage?.cropping(to: scaledCropRect)
        else {
            return nil
        }
        
        return UIImage(cgImage: croppedCGImage,
                       scale: originalImage.scale,
                       orientation: originalImage.imageOrientation)
    }

    
}

//MARK: - Gallery Setup
extension CameraVM {
    
    private func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            switch status {
            case .authorized:
                self?.setLastPhotoAsButtonImage()
            case .denied, .restricted, .notDetermined:
                return
            default:
                break
            }
        }
    }
    
    private func openGallery() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.setLastPhotoAsButtonImage()
                self.coordinator?.showImagePicker(delegate: self)
            case .denied, .restricted, .notDetermined:
                self.showGalleryErrorAlert()
            default:
                break
            }
        }
    }
    
    private func setLastPhotoAsButtonImage() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image,
                                              options: fetchOptions)
        
        guard let lastAsset = fetchResult.firstObject else { return }
        
        let imageManager = PHImageManager.default()
        let imageSize = CGSize(width: 50, height: 50)
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        imageManager.requestImage(for: lastAsset,
                                  targetSize: imageSize,
                                  contentMode: .aspectFill,
                                  options: requestOptions)
        { [weak self] image, _ in
            DispatchQueue.main.async {
                self?.lastImageFromGallery?(image)
            }
        }
    }
    
}

extension CameraVM: UIImagePickerControllerDelegate,
                     UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true, completion: nil)

        
        if let image = info[.originalImage] as? UIImage {
            coordinator?.openPhoto(image: image)
        }
    }
    
}

//MARK: - Toggle FlashMode
extension CameraVM {
    
    private func toggleFlashlight(with state: FlashlightMode) {
        guard let videoCaptureDevice else { return }
        
        if videoCaptureDevice.hasTorch {
            do {
                try videoCaptureDevice.lockForConfiguration()
                
                if  state == .off {
                    videoCaptureDevice.torchMode = .off
                    toggleFlashlight?(.off)
                } else if state == .on {
                    videoCaptureDevice.torchMode = .on
                    toggleFlashlight?(.on)
                }
                
                videoCaptureDevice.unlockForConfiguration()

            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
}

//MARK: Alert Service Use Cases
extension CameraVM {
    
    private func showCameraErrorAlert() {
        DispatchQueue.main.async {
            self.alertServise.showCameraError(
                title: "Camera Error",
                message: "This app requires access to your camera to allow you to capture new photos for editing.",
                goSettings: "Go to Settings") {
                if let appSettings =
                    URL(string: UIApplication.openSettingsURLString) {
                           UIApplication.shared.open(appSettings,
                                                     options: [:],
                                                     completionHandler: nil)
                    
                }
            }
        }
    }
    
    private func showGalleryErrorAlert() {
        DispatchQueue.main.async {
            self.alertServise.showCameraError(
                title: "Gallery Error",
                message: "This app requires access to your photo library to allow you to select and edit existing photos.",
                goSettings: "Go to Settings") {
                if let appSettings =
                    URL(string: UIApplication.openSettingsURLString) {
                           UIApplication.shared.open(appSettings,
                                                     options: [:],
                                                     completionHandler: nil)
                    
                }
            }
        }
    }
    
}

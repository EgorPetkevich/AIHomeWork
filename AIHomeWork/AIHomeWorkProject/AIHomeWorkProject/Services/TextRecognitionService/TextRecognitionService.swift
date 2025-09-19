//
//  TextRecognitionService.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.09.24.
//

import UIKit
import Vision

final class TextRecognitionService {
    
    typealias CompletionHandler = (String?) -> Void
    
    private let fileManager: FileManagerService = FileManagerService.instansce
    
    private func performTextRecognition<ResultType>(
        _ completion: @escaping ([VNRecognizedTextObservation]
        ) -> [ResultType]) -> (UIImage) -> [ResultType] {
            return { image in
                guard let cgImage = image.cgImage else { return [] }
                
                var scannedTextInfos: [ResultType] = []
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                
                let request = VNRecognizeTextRequest { request, error in
                    guard let observations = request.results as? [VNRecognizedTextObservation],
                          error == nil else {
                        print("Error: Text recognition failed.")
                        return
                    }
                    scannedTextInfos = completion(observations)
                }
                
                request.recognitionLanguages = ["en"]
                request.recognitionLevel = .accurate
                request.usesLanguageCorrection = true
                
                try? requestHandler.perform([request])
                
                return scannedTextInfos
            }
        }
    
    func recognizeText(fromImageWithID id: String, completion: CompletionHandler?) {
        guard let image = fileManager.read(directory: .TaskImages, with: id) else {
            print("Error: Image not found.")
            completion?(nil)
            return
        }
        
        let recognitionClosure = performTextRecognition { observations in
            // Extract the recognized string from each observation
            return observations.compactMap { $0.topCandidates(1).first?.string }
        }
        
        // Perform text recognition asynchronously
        DispatchQueue.global(qos: .userInitiated).async {
            let recognizedTexts = recognitionClosure(image)
            let recognizedText = recognizedTexts.joined(separator: " ")
            
            DispatchQueue.main.async {
                completion?(recognizedText.isEmpty ? nil : recognizedText)
            }
        }
    }
    
    func recognizeText(image: UIImage, completion: CompletionHandler?) {
        
        let recognitionClosure = performTextRecognition { observations in
            // Extract the recognized string from each observation
            return observations.compactMap { $0.topCandidates(1).first?.string }
        }
        
        // Perform text recognition asynchronously
        DispatchQueue.global(qos: .userInitiated).async {
            let recognizedTexts = recognitionClosure(image)
            let recognizedText = recognizedTexts.joined(separator: " ")
            
            DispatchQueue.main.async {
                completion?(recognizedText.isEmpty ? nil : recognizedText)
            }
        }
    }
}

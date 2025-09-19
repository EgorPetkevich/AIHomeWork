//
//  FileManagerService.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 19.09.24.
//

import UIKit

final class FileManagerService {
    
    typealias CompletionHandler = (Bool) -> Void
    
    enum NameOfDirectory: String {
        case TaskImages
    }
    
    static let instansce = FileManagerService()
    
    private init() { }
    
    static func creatDierectory(name directory: NameOfDirectory) {
        let documentURL = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
        let url = documentURL.appendingPathComponent(directory.rawValue)
        
        do {
            try FileManager.default.createDirectory(at: url,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            print("Error creating directory: \(error)")
        }
    }
    
    func save(directory: NameOfDirectory, image: UIImage,
              with path: String,
              completion: CompletionHandler?) {
        let documentURL = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
        let userPhotosURL = documentURL.appendingPathComponent(directory.rawValue)
        
        let userProfileURL = userPhotosURL.appendingPathComponent("\(path).jpg")
        
        if let data = image.jpegData(compressionQuality: 1.0){
            do {
                try data.write(to: userProfileURL)
                completion?(true)
                print(#function, "Successfully wrote to file!")
            } catch {
                completion?(false)
                print(#function, "Error writing to file: \(error)")
            }
        }
    }
    
    func read(directory: NameOfDirectory, with path: String) -> UIImage? {
        let documentURL = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
        let userPhotosURL = documentURL.appendingPathComponent(directory.rawValue)
        
        let userProfileURL = userPhotosURL.appendingPathComponent("\(path).jpg")
        
        do {
            let data = try Data(contentsOf: userProfileURL)
            if let image = UIImage(data: data) {
                print("File contents: \(image)")
                return image
            }
        } catch {
            print("Error reading file: \(error)")
        }
        return nil
    }
    
    func delete(directory: NameOfDirectory, with path: String, completion: CompletionHandler?) {
        let documentURL = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
        let userPhotosURL = documentURL.appendingPathComponent(directory.rawValue)
        
        let fileURL = userPhotosURL.appendingPathComponent("\(path).jpg")
        
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
                completion?(true)
                print(#function, "File successfully deleted!")
            } else {
                completion?(false)
                print(#function, "File does not exist at path.")
            }
        } catch {
            completion?(false)
            print(#function, "Error deleting file: \(error)")
        }
    }
    
}

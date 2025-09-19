//
//  OpenAIChatService.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import UIKit
import Storage

enum ChatRole: String {
    case user
    case assistant
}

struct ChatResponse: Codable {
    let id: String?
    let object: String?
    let created: Int?
    let choices: [Choice]?
}

struct Choice: Codable {
    let index: Int?
    let message: Message?
    let finish_reason: String?
}

struct Message: Codable {
    let role: String?
    let content: String?
}

class OpenAIChatService {
    
    typealias TaskCompletionHandler = ((ChatDTO?) -> Void)?
    
    private var apiKey: String = Constant.apiKey
    
    func convertImageToBase64(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        return imageData.base64EncodedString()
    }
    
    func fetchChat(dto: any DTODescription,
                   completion: TaskCompletionHandler) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            completion?(nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var messages: [[String: String]] = []
        for chat in dto.chat {
            let messageDict: [String: String] = [
                "role": chat.role,
                "content": chat.message
            ]
            messages.append(messageDict)
        }
        
        let jsonBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody)
            urlRequest.httpBody = jsonData
        } catch {
            completion?(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if error != nil {
                print("[ERROR: \(error)]")
                completion?(nil)
                return
            }
            
            guard let data = data else {
                completion?(nil)
                return
            }
            
            do {
                let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
                guard
                    let message = chatResponse.choices?.first?.message
                else {
                    completion?(nil)
                    return
                }
                
                let chatDTO = ChatDTO(
                    id: UUID().uuidString,
                    date: .now,
                    message: message.content ?? "",
                    role: message.role ?? ""
                )
                
                completion?(chatDTO)
            } catch {
                completion?(nil)
            }
        }
        
        task.resume()
    }
    
    enum OpenAIChatServiceError: Error {
        case invalidURL
        case invalidRequestBody
        case noData
        case networkError(Error)
        case invalidResponse
        case parsingError(Error)
        case storageFailure
    }
}

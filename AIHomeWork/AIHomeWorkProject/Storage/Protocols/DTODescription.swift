//
//  DTODescription.swift
//  Storage
//
//  Created by George Popkich on 13.09.24.
//

import Foundation
import CoreData

public protocol MODescription: NSManagedObject, NSFetchRequestResult {
    var identifier: String? { get }
    
    func apply(dto: any DTODescription)
    func toDTO() -> (any DTODescription)?
    
    func addToChat(_ value: ChatMO)
}

public protocol DTODescription {
    associatedtype MO: MODescription
    
    var id: String { get set }
    var date: Date { get set }
    var name: String { get set }
    var chat: [ChatDTO] { get set }
    
    func createMO(context: NSManagedObjectContext) -> MO?
    
    static func fromMO(_ mo: MO) -> Self?
}



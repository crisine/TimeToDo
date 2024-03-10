//
//  Todo.swift
//  TimeToDo
//
//  Created by Minho on 3/10/24.
//

import Foundation
import RealmSwift

class Todo: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var superId: ObjectId?
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted var priority: Int?
    @Persisted var createdDate: Date
    @Persisted var modifiedDate: Date
    @Persisted var startDate: Date?
    @Persisted var dueDate: Date?
    @Persisted var isDeleted = false
    
    convenience init(title: String, createdDate: Date, modifiedDate: Date) {
        self.init()
        self.title = title
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
    
}

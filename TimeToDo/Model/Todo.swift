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
    @Persisted var createdDate: Date = Date()
    @Persisted var modifiedDate: Date
    @Persisted var startDate: Date?
    @Persisted var dueDate: Date?
    @Persisted var isCompleted: Bool?
    @Persisted var estimatedPomodoroMinutes: Int?
    @Persisted var isDeleted: Bool?
    
    convenience init(superId: ObjectId? = nil, title: String, memo: String? = nil, priority: Int? = nil, modifiedDate: Date, startDate: Date? = nil, dueDate: Date? = nil, isCompleted: Bool = false, estimatedPomodoroMinutes: Int? = nil, isDeleted: Bool = false) {
        self.init()
        self.superId = superId
        self.title = title
        self.memo = memo
        self.priority = priority
        self.modifiedDate = modifiedDate
        self.startDate = startDate
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.estimatedPomodoroMinutes = estimatedPomodoroMinutes
        self.isDeleted = isDeleted
    }
    
}

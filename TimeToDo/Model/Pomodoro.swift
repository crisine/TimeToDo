//
//  Pomodoro.swift
//  TimeToDo
//
//  Created by Minho on 3/17/24.
//

import Foundation
import RealmSwift

final class Pomodoro: Object, Identifiable  {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var todoId: ObjectId
    @Persisted var elapsedMinutes: Int
    @Persisted var startedTime: Date
    @Persisted var endedTime: Date
    
    convenience init(todoId: ObjectId, elapsedMinutes: Int, startedTime: Date, endedTime: Date) {
        self.init()
        self.todoId = todoId
        self.elapsedMinutes = elapsedMinutes
        self.startedTime = startedTime
        self.endedTime = endedTime
    }
}

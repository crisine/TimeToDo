//
//  Pomodoro.swift
//  TimeToDo
//
//  Created by Minho on 3/17/24.
//

import Foundation
import RealmSwift

class Pomodoro: Object, Identifiable  {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var todoId: ObjectId
    @Persisted var elapsedMinutes: Int
    @Persisted var startedTime: Date
    @Persisted var endedTime: Date
    
}

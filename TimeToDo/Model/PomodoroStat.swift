//
//  PomodoroStat.swift
//  TimeToDo
//
//  Created by Minho on 3/16/24.
//

import Foundation

struct PomodoroStat: Hashable {
    
    let id = UUID()
    let totalPomodoroCount: Int
    let totalPomodoroMinutes: Int
    
}

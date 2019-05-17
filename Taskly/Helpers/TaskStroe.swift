//
//  TaskStroe.swift
//  Taskly
//
//  Created by 張駿彥 on 2019/2/23.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import Foundation

class TaskStore{
    var tasks = [[Task](), [Task]()]
    
    //add tasks
    func add(_ task: Task, at index: Int, isDone: Bool=false){
        let section = isDone ? 1:0
        tasks[section].insert(task, at: index)
    }
    
    //modify tasks
    func modify(_ task: Task,isDone:Int,row:Int){
        let section = isDone
        tasks[section][row].task = task.task
        tasks[section][row].date = task.date
    }
    
    //remove tasks
    @discardableResult func removeTask(at index: Int, isDone: Bool=false)->Task{
        let section = isDone ? 1:0
        
        return tasks[section].remove(at: index)
    }
}

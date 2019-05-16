//
//  Task.swift
//  Taskly
//
//  Created by 張駿彥 on 2019/2/23.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import Foundation

class Task: NSObject,NSCoding {
    
    var task: String?
    var date: String?
    var isDone: Bool?
    
    private let taskKey = "task"
    private let dateKey = "date"
    private let isDoneKey = "isDone"
    
    init(task: String,date: String, isDone: Bool = false){
        self.task = task
        self.date = date
        self.isDone = isDone
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(task, forKey: taskKey)
        aCoder.encode(date, forKey: dateKey)
        aCoder.encode(isDone, forKey: isDoneKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let task = aDecoder.decodeObject(forKey: taskKey) as? String,
            let date = aDecoder.decodeObject(forKey: dateKey) as? String,
            let isDone = aDecoder.decodeObject(forKey: isDoneKey) as? Bool
            else { return }
        
        self.task = task
        self.date = date
        self.isDone = isDone
    }
}

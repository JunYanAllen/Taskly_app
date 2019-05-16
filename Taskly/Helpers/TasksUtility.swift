//
//  TasksUtility.swift
//  Taskly
//
//  Created by 張駿彥 on 2019/2/26.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import Foundation

class TasksUtility{
    
    private static let key = "tasks"
    
    private static func archive(_ tasks:[[Task]]) -> Data?{
        return try? NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false)
    }
    
    static func fetch() -> [[Task]]? {
        guard let unarchivedData = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as? [[Task]] ?? [[]]
    }
    
    static func save(_ tasks: [[Task]]) {
        let archivedTasks = archive(tasks)
        
        UserDefaults.standard.set(archivedTasks, forKey: "tasks")
        UserDefaults.standard.synchronize()
    }
}

//
//  Task.swift
//  Taskly
//
//  Created by 張駿彥 on 2019/2/23.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import Foundation

class Task{
    var name: String
    var isDone: Bool
    
    init(name: String, isDone: Bool = false){
        self.name = name
        self.isDone = isDone
    }
}

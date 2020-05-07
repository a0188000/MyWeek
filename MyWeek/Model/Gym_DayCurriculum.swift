//
//  Gym_DayCurriculum.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/4.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import Foundation

struct Gym_DayCurriculum {
    var day: Int
    var students: [Gym_Student] = []
    
    init(day: Int, dictionary: [String: Any]) {
        self.day = day
        for (key, element) in dictionary {
            guard let studentDic = element as? [String: Any] else { break }
            self.students.append(.init(key: key, dictionary: studentDic))
        }
    }
}

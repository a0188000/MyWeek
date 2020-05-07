//
//  Gym_WeekCurriculum.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/4.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import Foundation

struct Gym_WeekCurriculum {
    var week: Int
    var dayCurriculum: [Gym_DayCurriculum] = []
    
    init(week: Int, dictionary: [String: Any]) {
        self.week = week
        for (day, element) in dictionary {
            var newDay = day.dropFirst()
            guard
                let elementDic = element as? [String: Any],
                let studentsDic = elementDic["Students"] as? [String: Any]
            else { break }
            self.dayCurriculum.append(.init(day: Int(day.dropFirst())!, dictionary: studentsDic))
        }
    }
}

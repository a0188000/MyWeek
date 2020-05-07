//
//  GYM_Student.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/4.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import Foundation

struct Gym_Student {
    
    var key: String = ""
    var name: String?
    var postion: Int = -1
    var typeCode: Int = 0
    
    init(key: String, dictionary: [String: Any]) {
        self.key = key
        self.name = dictionary["Name"] as? String
        self.postion = dictionary["Postion"] as? Int ?? -1
        self.typeCode = dictionary["TypeCode"] as? Int ?? 0
    }
    
    init(name: String, typeCode: StudentTypeCode) {
        self.name = name
        self.typeCode = typeCode.rawValue
    }
}

//
//  StudentTypeCode.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/7.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

enum StudentTypeCode: Int {
    case normal = 0
    case scheduled
    case busy
    case holiday
    
    var backgroundColor: UIColor {
        switch self {
        case .normal:    return .white
        case .scheduled: return .lightGray
        case .busy:      return .orange
        case .holiday:   return .red
        }
    }
}

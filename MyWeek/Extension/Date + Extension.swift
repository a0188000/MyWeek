//
//  Date + Extension.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/4.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

extension Date {
    func toDayTimestamp() -> TimeInterval? {
        let formatter = DateFormatter {
            $0.dateFormat = "yyyy/MM/dd"
        }
        return formatter.date(from: formatter.string(from: Date()))?.timeIntervalSince1970
    }
}

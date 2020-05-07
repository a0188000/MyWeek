//
//  UIColor + Extension.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/6.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
}

//
//  GeneralHelper.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/6.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class GeneralHelper {
    
    static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(x:0, y:0, width:size.width, height:size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

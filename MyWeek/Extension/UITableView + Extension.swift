//
//  UITableView + Extension.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/5.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

extension UITableView {
    public func weekRegister<T: UITableViewCell>(_ cellClass: T.Type) {
        self.register(cellClass.self, forCellReuseIdentifier: T.identifier)
    }
    
    public func weekDequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else { fatalError("") }
        return cell
    }
}

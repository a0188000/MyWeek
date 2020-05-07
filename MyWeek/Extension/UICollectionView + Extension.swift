//
//  UICollectionView + Extension.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/4/29.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func weekRegister<T: UICollectionViewCell>(_ cellClass: T.Type) {
        self.register(cellClass.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    public func weekDequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else { fatalError("") }
        return cell
    }
}

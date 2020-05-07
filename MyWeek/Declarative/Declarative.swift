//
//  Declarative.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/9.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

protocol Declarative {
    init()
}

extension NSObject: Declarative { }

extension Declarative where Self: NSObject {
    init(_ configureHandler: (Self) -> Void) {
        self.init()
        configureHandler(self)
    }
}

extension Declarative where Self: UIButton {
    init(type: UIButton.ButtonType, _ configureHandler: (Self) -> Void) {
        self.init(type: type)
        configureHandler(self)
    }
}

extension Declarative where Self: UICollectionView {
    init(layout: UICollectionViewLayout, _ configureHandler: (Self) -> Void) {
        self.init(frame: .zero, collectionViewLayout: layout)
        configureHandler(self)
    }
}

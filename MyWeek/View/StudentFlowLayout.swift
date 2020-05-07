//
//  SearchConditionCollectionViewLayout.swift
//  HouseFunBuy
//
//  Created by EVERTRUST on 2018/11/14.
//  Copyright © 2018 Truck Liu. All rights reserved.
//

import UIKit

protocol StudentFlowLayoutDelegate: UICollectionViewDelegateFlowLayout { }

class StudentCollectionViewFlowLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    
    var itemAttributes: [UICollectionViewLayoutAttributes] = []
    var delegate: StudentFlowLayoutDelegate?
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.itemAttributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributes = super.layoutAttributesForElements(in: rect)
        
        if let attributes = attributes, attributes.count > 0 {
            let firstAttr = attributes[0]
            var frame = firstAttr.frame
            frame.origin.x = 0
            firstAttr.frame = frame
        }
        if attributes?.count == 0 { return nil }
        for i in 1..<attributes!.count {
            let currentLayoutAttributes = attributes?[i]
            let prevLayoutAttributes = attributes?[i-1]
            let origin = prevLayoutAttributes?.frame.maxX
            if origin! + 6 + currentLayoutAttributes!.frame.size.width < self.collectionViewContentSize.width {
                var frame = currentLayoutAttributes!.frame
                frame.origin.x = origin! + 6
                currentLayoutAttributes?.frame = frame
            } else {
                var frame = currentLayoutAttributes!.frame
                frame.origin.x = 0
                currentLayoutAttributes?.frame = frame
            }
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}

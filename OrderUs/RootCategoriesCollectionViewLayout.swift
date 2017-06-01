//
//  RootCategoriesCollectionViewLayout.swift
//  OrderUs
//
//  Created by Muhammadali on 01/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

protocol RootCategoriesCollectionViewLayoutDelegate {
    func featuredCellChanged(to indexPath: IndexPath)
}

class RootCategoriesCollectionViewLayout: UICollectionViewLayout {
    var delegate: RootCategoriesCollectionViewLayoutDelegate?
    
    let dragOffset: CGFloat = 10
    
    var numberOfItems: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    var featuredCellIndex: Int {
        return  max(0, Int(collectionView!.contentOffset.y / dragOffset))
    }
    
    var collectionViewWidth: CGFloat {
        return collectionView!.bounds.width
    }
    
    var collectionViewHeight: CGFloat {
        return (CGFloat(numberOfItems) * dragOffset) + (collectionView!.bounds.height - dragOffset)
    }
    
    var featuredCellHeight: CGFloat {
        return collectionViewWidth
    }
    
    var standardCellHeight: CGFloat {
        return featuredCellHeight / 8
    }
    
    var cellWidth: CGFloat {
        return collectionViewWidth
    }
    
    var nextItemPercentageOffset: CGFloat {
        return (collectionView!.contentOffset.y / dragOffset) - CGFloat(featuredCellIndex)
    }
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        var y: CGFloat = 0
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.zIndex = item
            var height = standardCellHeight
            if item == featuredCellIndex {
                let yOffset = standardCellHeight * nextItemPercentageOffset
                y = collectionView!.contentOffset.y - yOffset
                delegate?.featuredCellChanged(to: indexPath)
                height = featuredCellHeight
            } else if item == featuredCellIndex + 1 && item < numberOfItems {
                height += max((featuredCellHeight - standardCellHeight) * nextItemPercentageOffset, 0)
                let maxY = y + standardCellHeight
                y = maxY - height
            }
            attribute.frame = CGRect(x: 0.0, y: y, width: cellWidth, height: height)
            cache.append(attribute)
            y = attribute.frame.maxY
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in cache {
            if rect.intersects(attribute.frame) {
                layoutAttributes.append(attribute)
            }
        }
        
        return layoutAttributes
    }
    
    
}

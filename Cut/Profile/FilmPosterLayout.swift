//
//  FilmPosterLayout.swift
//  Cut
//
//  Created by Kyle McAlpine on 15/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

class FilmPosterLayout: UICollectionViewLayout {
    
    let posterHeightToWidthRatio = 1.4918032787
    let minimumPosterWidth: CGFloat = 100
    
    var collectionViewWidth: CGFloat {
        return max(collectionView!.bounds.width, minimumPosterWidth)
    }
    
    var filmCount: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    
    var postersPerRow: Int {
        return Int(floor(collectionViewWidth / minimumPosterWidth))
    }
    
    var posterSize: CGSize {
        let width = collectionViewWidth / CGFloat(postersPerRow)
        let height = width * CGFloat(posterHeightToWidthRatio)
        return CGSize(width: width, height: height)
    }
    
    var numberOfRows: Int {
        guard filmCount >= postersPerRow else { return 0 }
        return Int(ceil(Double(filmCount) / Double(postersPerRow)))
    }
    
    override var collectionViewContentSize: CGSize {
        let width = collectionViewWidth
        let height = CGFloat(numberOfRows) * posterSize.height
        return CGSize(width: width, height: height)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let row = Int(floor(Double(indexPath.item) / Double(postersPerRow)))
        let rowIndex = indexPath.item - (row * postersPerRow)
        
        let posterSize = self.posterSize
        let origin = CGPoint(x: CGFloat(rowIndex) * posterSize.width, y: CGFloat(row) * posterSize.height)
        
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attrs.frame = CGRect(origin: origin, size: posterSize)
        
        return attrs
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard filmCount > 0 else { return nil }
        
        let topY = max(0, rect.origin.y)
        
        var startIndex = Int(floor(topY / posterSize.height)) * postersPerRow
        var endIndex = (Int(floor((topY + rect.height)  / posterSize.height)) * postersPerRow) + postersPerRow
        
        startIndex = min(startIndex, filmCount - 1)
        endIndex = min(endIndex, filmCount - 1)
        
        return (startIndex...endIndex).map() { IndexPath(item: $0, section: 0) }.flatMap(layoutAttributesForItem)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

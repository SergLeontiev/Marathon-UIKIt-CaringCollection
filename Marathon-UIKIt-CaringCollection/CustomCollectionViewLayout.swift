//
//  CustomCollectionViewLayout.swift
//  Marathon-UIKIt-CaringCollection
//
//  Created by Sergey Leontiev on 26.11.24..
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {
    let itemSize = CGSize(width: 250, height: 350)
    let spacing: CGFloat = 10
    private var cellLayoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cellLayoutAttributes = [:]
    }
    
    override func prepare() {
        guard let collectionView else { return }
        
        let itemCount = collectionView.numberOfItems(inSection: 0)
        (0...itemCount - 1).forEach { item in
            let indexPath = IndexPath(item: item, section: 0)
            cellLayoutAttributes[indexPath] = layoutAttributesForItem(at: indexPath)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            guard let collectionView else { return .zero }
            guard collectionView.frame != .zero else { return .zero }
            let maxX = cellLayoutAttributes.values.max(by: { $0.frame.maxX < $1.frame.maxX })?.frame.maxX ?? 0
            return CGSize(width: maxX + spacing, height: collectionView.frame.height)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cellLayoutAttributes.values.filter { rect.intersects($0.frame) }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView else { return false }
        return newBounds.height != collectionView.bounds.height
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if cellLayoutAttributes[indexPath] != nil {
            return cellLayoutAttributes[indexPath]
        }
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(origin: originForItem(at: indexPath.item), size: itemSize)
        
        return attributes
    }
    
    private func originForItem(at index: Int) -> CGPoint {
        let x = itemSize.width * CGFloat(index) + spacing * CGFloat(index)
        return CGPoint(x: x, y: 75)
    }
}

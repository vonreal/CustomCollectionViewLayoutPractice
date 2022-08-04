//
//  PhotoLayout.swift
//  CustomCollectionViewLayoutPractice
//
//  Created by 나지운 on 2022/08/04.
//

import UIKit

protocol PhotoLayoutDelgate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGSize
}

class PhotoLayout: UICollectionViewLayout {
    
    weak var delegate: PhotoLayoutDelgate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 3
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
//        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        guard let collectionView = collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoSize = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? CGSize(width: 100, height: 100)
            
            let cellWidth = columnWidth
            let cellHeight = photoSize.height * cellWidth / photoSize.width
            let height = cellPadding * 2 + cellHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
              
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
      
      for attributes in cache {
        if attributes.frame.intersects(rect) {
          visibleLayoutAttributes.append(attributes)
        }
      }
      return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      return cache[indexPath.item]
    }
}

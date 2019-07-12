//
//  JHPinterestFlowLayout.swift
//  JHPinterestFlowLayout
//
//  Created by 윤중현 on 13/05/2019.
//  Copyright © 2019 tokijh. All rights reserved.
//

import UIKit

public final class JHPinterestFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Lifecycle

    public override init() {
        super.init()
        setup()
    }

    convenience init(delegate: JHPinterestFlowLayoutDelegate) {
        self.init()
        self.delegate = delegate
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.scrollDirection = .vertical
    }

    // MARK: - Property

    public weak var delegate: JHPinterestFlowLayoutDelegate?

    private var attributesCache: [[UICollectionViewLayoutAttributes]] = []
    private var contentWidth: CGFloat {
        guard let collectionView = self.collectionView else { return 0.0 }
        return collectionView.bounds.width
    }
    private var contentHeight: CGFloat = 0.0

    // MARK: - UICollectionViewFlowLayout

    public override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.attributesCache[indexPath.section][indexPath.row]
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attributesCache.flatMap({ $0 }).filter({ $0.frame.intersects(rect) })
    }

    public override func prepare() {
        guard self.attributesCache.isEmpty,
            let collectionView = self.collectionView
            else { return }

        let layoutWidth = collectionView.bounds.width
        let delegate = self.delegate

        var top: CGFloat = 0

        self.attributesCache = []
        var columnHeights: [[CGFloat]] = []

        let numberOfSections = collectionView.numberOfSections

        for section in 0 ..< numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)

            let numberOfColumns = delegate?.jhPinterestFlowLayoutDelegate(numberOfColumsInSection: section) ?? 1
            let columnSpacing = delegate?.jhPinterestFlowLayoutDelegate(columnSpacingForSectionAt: section) ?? 0
            let sectionInsets = delegate?.jhPinterestFlowLayoutDelegate(insetForSectionAt: section) ?? .zero
            let sectionSpacing = delegate?.jhPinterestFlowLayoutDelegate(sectionSpacingForSectionAt: section) ?? 0

            top += sectionInsets.top

            columnHeights.append((0 ..< numberOfColumns).map({ _ in top }))

            let sectionWidth: CGFloat = (layoutWidth - sectionInsets.left - sectionInsets.right)
            let columnSpacingWidths: CGFloat = CGFloat(numberOfColumns - 1) * columnSpacing
            let columnWidth: CGFloat = (sectionWidth - columnSpacingWidths) / CGFloat(numberOfColumns)

            var attributes: [UICollectionViewLayoutAttributes] = []

            for item in 0 ..< numberOfItems {
                let columnIndex = columnHeights[section].enumerated().min(by: { $0.element < $1.element })?.offset ?? 0 // columnHeights[section] 중에서 가장 작은 높이의 Index
                let indexPath = IndexPath(item: item, section: section)
                let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                let width = columnWidth
                let height = delegate?.jhPinterestFlowLayoutDelegate(heightForItemAt: indexPath) ?? 0.0
                let size = CGSize(width: width, height: height)

                let positionX = sectionInsets.left + (columnWidth + columnSpacing) * CGFloat(columnIndex)
                let positionY = columnHeights[section][columnIndex]
                let position = CGPoint(x: positionX, y: positionY)

                let frame = CGRect(origin: position, size: size)

                layoutAttributes.frame = frame
                attributes.append(layoutAttributes)

                columnHeights[section][columnIndex] = frame.maxY + columnSpacing
            }

            self.attributesCache.append(attributes)

            let columnIndex = columnHeights[section].enumerated().max(by: { $0.element < $1.element })?.offset ?? 0 // columnHeights[section] 중에서 가장 큰 높이의 Index
            top = columnHeights[section][columnIndex] + sectionSpacing + sectionInsets.bottom

            columnHeights[section] = (0 ..< columnHeights[section].count).map({ _ in top })
        }

        self.contentHeight = columnHeights.last?.first ?? 0.0
    }
}

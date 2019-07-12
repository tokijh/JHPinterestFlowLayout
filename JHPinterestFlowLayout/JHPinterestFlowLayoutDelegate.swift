//
//  JHPinterestFlowLayoutDelegate.swift
//  JHPinterestFlowLayout
//
//  Created by 윤중현 on 13/05/2019.
//  Copyright © 2019 tokijh. All rights reserved.
//

import UIKit

public protocol JHPinterestFlowLayoutDelegate: class {
    // 가로에 배치 수
    func jhPinterestFlowLayoutDelegate(numberOfColumsInSection section: Int) -> Int

    // Cell 간격
    func jhPinterestFlowLayoutDelegate(columnSpacingForSectionAt section: Int) -> CGFloat

    // Section별 ContentInset
    func jhPinterestFlowLayoutDelegate(insetForSectionAt section: Int) -> UIEdgeInsets

    // Section 간격
    func jhPinterestFlowLayoutDelegate(sectionSpacingForSectionAt section: Int) -> CGFloat

    // Cell 높이
    func jhPinterestFlowLayoutDelegate(heightForItemAt indexPath: IndexPath) -> CGFloat
}

extension JHPinterestFlowLayoutDelegate {
    func jhPinterestFlowLayoutDelegate(numberOfColumsInSection section: Int) -> Int {
        return 1
    }

    func jhPinterestFlowLayoutDelegate(columnSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func jhPinterestFlowLayoutDelegate(insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func jhPinterestFlowLayoutDelegate(sectionSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func jhPinterestFlowLayoutDelegate(heightForItemAt indexPath: IndexPath) -> CGFloat {
        return 0.0
    }
}

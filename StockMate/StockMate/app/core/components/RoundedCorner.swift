//
//  RoundedCorner.swift
//  StockMate
//
//  Created by Admin on 10/26/25.
//

import SwiftUI

// 특정 모서리만 둥글게 처리할 수 있는 커스텀 Shape 구조체
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity          // 둥근 모서리의 반경 (기본값은 무한대)
    var corners: UIRectCorner = .allCorners  // 둥글게 적용할 모서리 (기본값: 전체 모서리)
    
    // 지정된 모서리에만 둥근 경로를 적용하여 Path 생성
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

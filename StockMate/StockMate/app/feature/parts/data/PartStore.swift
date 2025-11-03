//
//  PartStore.swift
//  StockMate
//
//  Created by Admin on 11/3/25.
//

import Foundation

@MainActor
final class PartStore: ObservableObject {
    @Published var parts: [PartDetail] = []
    
    func addPart(_ part: PartDetail) {
        if let index = parts.firstIndex(where: { $0.id == part.id }) {
            parts[index].quantity += 1  // 이미 존재하면 수량만 +1
        } else {
            var newPart = part
            newPart.quantity = 1
            parts.append(newPart)
        }
    }

    func clear() {
        parts.removeAll()
    }
    
    // ✅ 수량 변경용 메서드 추가
    func increaseQuantity(for part: PartDetail) {
        if let index = parts.firstIndex(where: { $0.id == part.id }) {
            parts[index].quantity += 1
            objectWillChange.send() // 수동 갱신 트리거
        }
    }

    func decreaseQuantity(for part: PartDetail) {
        if let index = parts.firstIndex(where: { $0.id == part.id }),
           parts[index].quantity > 1 {
            parts[index].quantity -= 1
            objectWillChange.send()
        }
    }
}

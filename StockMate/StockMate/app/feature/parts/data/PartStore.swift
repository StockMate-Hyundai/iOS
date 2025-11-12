//
//  PartStore.swift
//  StockMate
//
//  Created by Admin on 11/3/25.
//

import Foundation

// 부품 출고 화면에서 선택된 부품들을 관리하는 상태 저장 클래스
@MainActor
final class PartStore: ObservableObject {
    @Published var parts: [PartDetail] = []
    
    // 부품 추가
    func addPart(_ part: PartDetail) {
        if let index = parts.firstIndex(where: { $0.id == part.id }) {
            parts[index].quantity += 1  // 이미 존재하면 수량만 +1
        } else {
            var newPart = part
            newPart.quantity = 1
            parts.append(newPart)
        }
    }

    // 선택된 부품 전체 초기화
    func clear() {
        parts.removeAll()
    }
    
    // 수량 변경용 메서드 추가
    func increaseQuantity(for part: PartDetail) {
        if let index = parts.firstIndex(where: { $0.id == part.id }) {
            parts[index].quantity += 1
            objectWillChange.send() // 수동 갱신 트리거
        }
    }

    // 부품 수량 감소 (최소 1개까지)
    func decreaseQuantity(for part: PartDetail) {
        if let index = parts.firstIndex(where: { $0.id == part.id }),
           parts[index].quantity > 1 {
            parts[index].quantity -= 1
            objectWillChange.send()
        }
    }
    
    // 수량 감소 후 1개 이하일 경우 목록에서 제거
    func decreaseQuantityOrRemove(for part: PartDetail) {
        if let index = parts.firstIndex(where: { $0.id == part.id }) {
            if parts[index].quantity > 1 {
                parts[index].quantity -= 1
            } else {
                parts.remove(at: index)
            }
            objectWillChange.send()
        }
    }
}

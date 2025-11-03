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
            // 이미 있으면 수량만 1 증가
            parts[index].quantity += 1
        } else {
            parts.append(part)
        }
    }

    func updateQuantity(for partId: Int, to quantity: Int) {
        if let index = parts.firstIndex(where: { $0.id == partId }) {
            parts[index].quantity = quantity
        }
    }

    func removePart(_ partId: Int) {
        parts.removeAll { $0.id == partId }
    }

    func makeRequestPayload() -> [[String: Any]] {
        parts.map { ["partId": $0.id, "quantity": $0.quantity] }
    }

    func clear() {
        parts.removeAll()
    }
}

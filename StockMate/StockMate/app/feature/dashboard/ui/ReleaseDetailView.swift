//
//  ReleaseDetailView.swift
//  StockMate
//
//  Created by Admin on 11/2/25.
//

import SwiftUI

struct ReleaseDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let history: HistoryItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 부품 리스트
                VStack(alignment: .leading, spacing: 7) {
                    Text("출고 품목 (\(history.items.count)개)")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.leading)
                    
                    // 처리일자 포맷팅
                    Text("처리일자: \(formattedDate3(history.createdAt))")
                        .font(.system(size: 15))
                        .foregroundColor(Color.textGray1)
                        .padding(.leading)

                    ForEach(history.items) { part in
                        ReleasePartCard(part: part)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color.Light)
        .navigationTitle("출고 상세")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}

struct ReleasePartCard: View {
    let part: HistoryPart

    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            // 상단 카테고리
            Text(part.categoryName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.black)
            
            Divider()
                .frame(height: 0.2)
                .background(Color.textGray2)
            
            HStack(alignment: .center, spacing: 12) {
                AsyncImage(url: URL(string: part.image)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 64, height: 64)
                .cornerRadius(10)

                VStack(alignment: .leading, spacing: 4) {
                    Text(part.korName)
                        .font(.system(size: 14, weight: .bold))
                        .lineLimit(1)

                    Text("\(part.model) / \(part.trim) / \(part.price)원 / \(part.historyQuantity)개")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Text("\(part.price * part.historyQuantity)원")
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                }

                Spacer()

             
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}

#Preview {
    ReleaseDetailView(history: HistoryItem(
        id: 1,
        memberId: 1,
        orderId: 2,
        orderNumber: "ORD-1234",
        message: "출고 완료",
        status: "RELEASED",
        type: "RELEASE",
        createdAt: "2025-11-01T12:30:00",
        updatedAt: "2025-11-01T12:40:00",
        userInfo: nil,
        items: [
            HistoryPart(id: 1, name: "partA", price: 1000, image: "", trim: "basic", model: "A1", category: 1, korName: "부품A", engName: "PartA", categoryName: "카테고리A", amount: 5, code: "P001", location: "A-01", cost: 500, historyQuantity: 3)
        ]
    ))
}


func formattedDate3(_ timestamp: String) -> String {
    let inputFormats = [
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS",
        "yyyy-MM-dd'T'HH:mm:ss.SSS",
        "yyyy-MM-dd'T'HH:mm:ss"
    ]

    let trimmed = timestamp.trimmingCharacters(in: .whitespacesAndNewlines)
    let parser = DateFormatter()
    parser.locale = Locale(identifier: "en_US_POSIX")
    parser.timeZone = TimeZone(identifier: "Asia/Seoul") // 서버 시간 기준으로 맞춤

    var date: Date? = nil
    for format in inputFormats {
        parser.dateFormat = format
        if let parsed = parser.date(from: trimmed) {
            date = parsed
            break
        }
    }

    guard let finalDate = date else { return timestamp }

    // 출력도 한국시간으로
    let output = DateFormatter()
    output.locale = Locale(identifier: "ko_KR")
    output.timeZone = TimeZone(identifier: "Asia/Seoul")
    output.dateFormat = "yyyy.MM.dd HH:mm:ss"

    return output.string(from: finalDate)
}

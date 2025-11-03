//
//  UsedPartListSheetView.swift
//  StockMate
//
//  Created by Admin on 11/4/25.
//


//
//  UsedPartListSheetView.swift
//  StockMate
//
//  Created by Admin on 11/4/25.
//

import SwiftUI

struct UsedPartListSheetView: View {
    @EnvironmentObject var partStore: PartStore
    var onUseParts: (() -> Void)? // ‘사용 처리’ 버튼 액션 콜백
    var onRescan: (() -> Void)? // ✅ 다시 스캔 콜백 추가

    var body: some View {
        NavigationStack {
            VStack {
                if partStore.parts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "cube.box")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray.opacity(0.6))
                        Text("추가된 부품이 없습니다.")
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 100)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach($partStore.parts) { $part in  // ✅ 바인딩으로 변경 ($ 붙임)
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: part.image)) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Color.gray.opacity(0.2)
                                    }
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(part.korName)
                                            .font(.headline)
                                        Text(part.model)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text(part.categoryName)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    // ✅ 수량 조절 버튼
                                    HStack {
                                        Button("-") { if part.quantity > 1 { part.quantity -= 1 } }
                                        Text("\(part.quantity)")
                                        Button("+") { part.quantity += 1 }
                                    }
                                    .padding(.trailing, 4)
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete { indexSet in
                                partStore.parts.remove(atOffsets: indexSet)
                            }
                        }
                        .listStyle(.plain)
                    }
                }

                // 🔹 다시 스캔 버튼
                 Button {
                     onRescan?()
                 } label: {
                     Text("다시 스캔")
                         .font(.headline)
                         .foregroundColor(.blue)
                         .frame(maxWidth: .infinity)
                         .padding()
                         .background(Color.blue.opacity(0.1))
                         .cornerRadius(10)
                 }
                 .padding(.bottom, 16)
                
                // ✅ 사용 처리 버튼
                Button {
                    onUseParts?()
                } label: {
                    Text("사용 처리")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(partStore.parts.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(partStore.parts.isEmpty)
                .padding(.bottom, 16)
            }
            .navigationTitle("사용할 부품 목록")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("전체삭제") {
                        partStore.clear()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

//
//  UsedPartListSheetView.swift
//  StockMate
//
//  Created by Admin on 11/4/25.
//

import SwiftUI

struct UsedPartListSheetView: View {
    @EnvironmentObject var partStore: PartStore
    var onUseParts: (() -> Void)?   // ‘사용 처리’ 버튼 액션 콜백
    var onRescan: (() -> Void)?     // 다시 스캔 콜백 추가

    var body: some View {
            VStack (alignment: .center){
                // 상단 헤더
                ZStack {
                    Text("사용할 부품")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)

                    HStack {
                        Spacer()
                        Button("전체 삭제") {partStore.clear()}
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red)
                        .padding(.trailing, 20)
                    }
                }
                .padding(.vertical, 26)
                .background(Color.white)
               
                
                // 내용 영역
                ScrollView {
                    if partStore.parts.isEmpty {
                        // 부품 목록 전체 삭제의 경우
                        VStack(spacing: 12) {
                            Image(systemName: "cube.box")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray.opacity(0.6))
                            Text("추가된 부품이 없습니다.")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                    } else {
                        LazyVStack {
                            ForEach($partStore.parts) { $part in  // 바인딩으로 변경 ($ 붙임)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(part.categoryName)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    Divider()
                                        .frame(height: 0.2)
                                        .background(Color.textGray2)
                                    
                                    HStack(alignment: .center, spacing: 12) {
                                        AsyncImage(
                                            url: URL(string: part.image)
                                        ) { image in
                                            image.resizable().scaledToFill()
                                        } placeholder: {
                                            Color.gray.opacity(0.2)
                                        }
                                        .frame(width: 64, height: 64)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 10)
                                        )
                                        
                                        VStack(alignment: .leading,spacing: 6) {
                                            Text(part.korName)
                                                .font( .system(size: 13, weight: .bold))
                                                .foregroundColor(.black)
                                                .lineLimit(2)
                                            Text("\((part.trim)) / \((part.model))")
                                            .font(.system(size: 12))
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                            Text("\(part.price)원")
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(.black)
                                        }
                                        
                                        Spacer()
                                        
                                        // 수량 조절 버튼 (디자인 개선)
                                        HStack(spacing: 10) {
                                            Button {
                                                partStore.decreaseQuantityOrRemove(for: part)
                                            } label: {
                                                Image(systemName: "minus")
                                                    .font(.system(size: 14, weight: .regular))
                                                    .frame(width: 13,height: 13)
                                                    .foregroundColor(.black)
                                            }
                                            Text("\(part.quantity)")
                                                .font(.system(size: 15, weight: .medium))
                                                .frame(width: 20)
                                            Button {
                                                partStore.increaseQuantity(for: part)
                                            } label: {
                                                Image(systemName: "plus")
                                                    .font(.system(size: 14, weight: .regular))
                                                    .frame(width: 13,height: 13)
                                                    .foregroundColor(.black)
                                            }
                                        }
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 8)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke( Color.LightBlue03, lineWidth: 1)
                                        )
                                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 4 )
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 4)
                                
                            }
                            .onDelete { indexSet in
                                partStore.parts.remove(atOffsets: indexSet)
                            }
                        }
                        .listStyle(.plain)
                        
                    }
                }
                .padding(7)
                .frame(maxHeight: .infinity)
            
                HStack{
                    // 다시 스캔 버튼
                    Button {
                        onRescan?()
                    } label: {
                        Text("부품 추가")
                            .font(.headline)
                            .foregroundColor(.Primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(9999)
                            .background(
                                RoundedRectangle(cornerRadius: 9999)
                                    .stroke(Color.Primary, lineWidth: 2)
                            )
                    }
                    .padding(.bottom, 16)
                
                    // 사용 처리 버튼
                    Button {
                        onUseParts?()
                    } label: {
                        Text("사용 처리")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                partStore.parts.isEmpty ? Color.gray : Color.Primary
                            )
                            .cornerRadius(9999)
                    }
                    .disabled(partStore.parts.isEmpty)
                    .padding(.bottom, 16)
                }
                .padding(.horizontal)
            }
    }
}

// MARK: - 프리뷰
@MainActor
struct UsedPartListSheetView_Previews: PreviewProvider {
    static var previewStore: PartStore = {
        let store = PartStore()
        store.parts = [
            PartDetail(
                id: 1,
                price: 10000,
                image: "https://via.placeholder.com/150",
                trim: "준준형/소형",
                model: "아반떼MD",
                korName: "액츄에이터 - 템퍼러처 도어",
                categoryName: "전기/램프",
                quantity: 2
            ),
            PartDetail(
                id: 2,
                price: 25000,
                image: "https://via.placeholder.com/150",
                trim: "준준형/소형",
                model: "아반떼 MD",
                korName: "스위치 어셈블리 - 도어",
                categoryName: "전기/램프",
                quantity: 1
            )
        ]
        return store
    }()

    static var previews: some View {
        NavigationStack {
            UsedPartListSheetView(
                onUseParts: { print("사용 처리 버튼 눌림") },
                onRescan: { print("다시 스캔 버튼 눌림") }
            )
            .environmentObject(previewStore)
        }
    }
}



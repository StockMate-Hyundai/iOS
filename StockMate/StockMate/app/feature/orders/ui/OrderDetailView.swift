//
//  OrderDetailView.swift
//  StockMate
//
//  Created by Admin on 10/22/25.
//

import SwiftUI

struct OrderDetailView: View {
    let orderId: Int
    @ObservedObject var orderViewModel: OrderViewModel
    @StateObject private var viewModel = OrderDetailViewModel()

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let order = viewModel.order {
                VStack(spacing: 16) {
                    VStack {
                        DeliveryStatusView(currentStep: deliveryStep(for: order.orderStatus))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    
                    // ✅ 주문 정보
                    VStack(alignment: .leading, spacing: 6) {
                        Text(formatDate(order.createdAt))
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.bottom, 4)
                        
                            infoRow("주문번호", order.orderNumber)
                            .padding(.bottom, 4)

                        
                        HStack(alignment: .top, spacing: 6){
                                Text("상태")
                                    .font(.system(size: 14))
                            Spacer()
                                Text(statusText(order.orderStatus))
                                    .font(.system(size: 13, weight: .semibold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(statusBdColor(order.orderStatus))
                                    .foregroundColor(statusColor(order.orderStatus))
                                    .cornerRadius(12)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // ✅ 이거 추가
                    .padding(.all, 20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 3, y: 2)

                    // 승인 반려인 경우에만 반려메세지 칸 생성
                    if order.orderStatus == "REJECTED" {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("반려 메세지")
                                .font(.system(size: 15, weight: .semibold))
                                .padding(.bottom, 4)
                            Text(order.rejectedMessage ?? "-")
                                .font(.system(size: 14))
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading) // ✅ 여기도 추가
                        .padding(.all, 20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
                    }
                    
                    // ✅ 배송 정보
                    VStack(alignment: .leading, spacing: 6) {
                        Text("배송정보")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.bottom, 4)
                        
                        infoRow("주문자명", order.userInfo?.owner ?? "-")
                        infoRow("주소", order.userInfo?.address ?? "-")
                        // ✅ 운송장정보 안전 처리
                        let trackingText: String = {
                            if let carrier = order.carrier,
                               let trackingNo = order.trackingNumber,
                               !carrier.isEmpty,
                               !trackingNo.isEmpty {
                                return "\(carrier): \(trackingNo)"
                            }
                            return "-"
                        }()
                        infoRow("운송장번호", trackingText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // ✅ 여기도 추가
                    .padding(.all, 20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
                    
                    
                    // 요청사항 따로 빼기
                    VStack(alignment: .leading, spacing: 6) {
                        Text("요청사항")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.bottom, 4)
                            
                        Text(order.etc ?? "")
                            .font(.system(size: 14))
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // ✅ 여기도 추가
                    .padding(.all, 20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
                   
                    
                    // ✅ 주문 상품
                    OrderSectionCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("주문 상품 \(order.orderItems.count)개")
                                .font(.system(size: 15, weight: .semibold))
                            
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(order.orderItems, id: \.partId) { item in
                                    Text(item.partDetail.categoryName)
                                        .font(.system(size: 12, weight: .semibold))
                                    
                                    HStack(alignment: .top, spacing: 12) {
                                        AsyncImage(url: URL(string: item.partDetail.image)) { img in
                                            img.resizable().scaledToFill()
                                        } placeholder: {
                                            Color.gray.opacity(0.1)
                                        }
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(4)
                                        .clipped()
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.partDetail.korName)
                                                .font(.system(size: 14, weight: .semibold))
                                            Text("\(item.partDetail.model) / \(item.partDetail.trim) / \(formatPrice(item.partDetail.price))원 / \(item.amount)개")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            Text("\(formatPrice(item.partDetail.price * item.amount))원")
                                                .font(.system(size: 14, weight: .bold))
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading) // ✅ 왼쪽 정렬 강제
                                }
                            }
                            .padding(.top, 8) // 위 여백만 살짝
                        }
                        .frame(maxWidth: .infinity, alignment: .leading) // ✅ 섹션 전체도 왼쪽으로 정렬
                    }


                    // ✅ 결제 정보
                    OrderSectionCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("결제 정보")
                                .font(.system(size: 15, weight: .semibold))
                            
                            if order.paymentType == "DEPOSIT" {
                                infoRow("결제 수단", "예치금")
                            } else {
                                infoRow("결제 수단", "카드 결제")
                            }
                            
                            infoRow("상품금액", "\(formatPrice(order.totalPrice))원")
                            infoRow("배송희망일", formatDateOrDash(order.requestedShippingDate))
                            Divider().padding(.vertical, 4)
                            HStack {
                                Text("총 결제 금액")
                                    .font(.headline)
                                Spacer()
                                Text("\(formatPrice(order.totalPrice))원")
                                    .font(.headline.bold())
                                    .foregroundColor(.Primary)
                            }
                        }
                    }

                    // ✅ 하단 버튼
                    HStack(spacing: 12) {
                        // 왼쪽: 영수증 확인
                        NavigationLink(destination: ReceiptView(orderId: order.id)) {
                            Text("영수증 확인")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color.Primary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.Primary, lineWidth: 1.5)
                                )
                                .cornerRadius(10)
                        }


                        // 오른쪽 버튼: 주문 상태에 따라 변경
                        if order.orderStatus == "ORDER_COMPLETED" ||
                           order.orderStatus == "PAY_COMPLETED" {
                            // "주문취소" → 주문완료/결제완료/승인대기
                            Button(action: {
                                Task {
                                    await orderViewModel.cancelOrder(orderId: orderId)
                                }
                            }) {
                                Text("주문 취소")
                                    .font(.system(size: 15, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(Color(hex: "#1D4ED8"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                           
                        } else if order.orderStatus == "SHIPPING" {
                            // "입고 하기" → 입고대기/배송완료
                            Button(action: {
                                // TODO: 입고 처리 버튼
                            }) {
                                Text("입고 처리")
                                    .font(.system(size: 15, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(Color(hex: "#1D4ED8"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                           
                        } else {
                            // 👉 나머지 상태 → "재주문하기" 버튼
                            Button(action: {
                                // TODO: 평가 액션 처리
                            }) {
                                Text("재주문하기")
                                    .font(.system(size: 15, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(Color(hex: "#1D4ED8"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }

                        }
                    }
                    .padding(.top, 5)

                }
                .padding(.horizontal, 20) // ✅ 전체 섹션 동일 여백
                .padding(.vertical, 16)

            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color.Light)
        .navigationTitle("주문 내역 상세")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchOrderDetail(orderId: orderId)
        }
    }

    // MARK: - Helper
    func infoRow(_ left: String, _ right: String) -> some View {
        HStack {
            Text(left)
            Spacer()
            Text(right)
        }
        .font(.system(size: 14))
    }

 
}

// ✅ 카드 레이아웃 통일용
struct OrderSectionCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
                .padding(20)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
    }
}

func formatPrice(_ value: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
}

func formatDateOrDash(_ isoDate: String?) -> String {
    guard let isoDate = isoDate, !isoDate.isEmpty else {
        return "-"
    }
    let comps = isoDate.split(separator: "T").first?.split(separator: "-") ?? []
    guard comps.count == 3 else { return "-" }
    return "\(comps[0])년 \(comps[1])월 \(comps[2])일"
}

func deliveryStep(for status: String) -> Int {
    // 6 -> 전체 회색
    // 4 -> 전체 파란색
    switch status {
    case "ORDER_COMPLETED": return 0    // 주문 완료
        
    // 결제 후 결과에 따라 결제 실패 or 완료
    case "FAILED": return 6             // 결제 실패
    case "PAY_COMPLETED": return 0      // 결제 완료
        
    // 결제 완료 상태에서 지점이 주문 취소
    case "CANCELLED": return 6          // 주문 취소
        
    // 본사에서 "결제 완료"에 대해서 주문을 반려 or 승인
    case "REJECTED": return 6           // 주문 반려
    case "APPROVAL_ORDER": return 1     // 주문 승인
    
    // 창고관리자가 "주문 승인"에 대해서 송장(인보이스)를 뽑으면 출고 대기
    case "PENDING_SHIPPING": return 2   // 출고 대기
    
    // 창고관리자가 QR을 스캔하여 출고처리 하면 배송중
    case "SHIPPING": return 3           // 배송중
    
    // 지점에서 QR을 스캔하여 입고 완료 처리
    case "RECEIVED": return 4          // 입고 완료
    default: return 6
    }
}

func formatDate(_ isoDate: String) -> String {
    let comps = isoDate.split(separator: "T").first?.split(separator: "-") ?? []
    guard comps.count == 3 else { return isoDate }
    return "\(comps[0])년 \(comps[1])월 \(comps[2])일"
}

// 0: 초록, 1: 빨강, 2: 주황, 3: 노랑, 4: 파랑, 5: 보라

func statusText(_ status: String) -> String {
    switch status {
    case "ORDER_COMPLETED": return "주문 완료"      // 주문 완료
        
    // 결제 후 결과에 따라 결제 실패 or 완료
    case "FAILED": return "결제 실패"               // 결제 실패
    case "PAY_COMPLETED": return "결제 완료"        // 결제 완료
        
    // 결제 완료 상태에서 지점이 주문 취소
    case "CANCELLED": return "주문 취소"            // 주문 취소
        
    // 본사에서 "결제 완료"에 대해서 주문을 반려 or 승인
    case "REJECTED": return "결제 실패"             // 주문 반려
    case "APPROVAL_ORDER": return "출고 대기"       // 주문 승인
        
    // 창고관리자가 "주문 승인"에 대해서 송장(인보이스)를 뽑으면 출고 대기
    case "PENDING_SHIPPING": return "출고 대기"     // 출고 대기
    
    // 창고관리자가 QR을 스캔하여 출고처리 하면 배송중
    case "SHIPPING": return "배송중"               // 배송중
    
    // 지점에서 QR을 스캔하여 입고 완료 처리
    case "RECEIVED": return "입고 완료"             // 입고 완료
    default: return "알 수 없음"
    }
}

func statusColor(_ status: String) -> Color {
    switch status {
    case "ORDER_COMPLETED": return .StatusGreen
        
    case "FAILED": return .Danger
    case "PAY_COMPLETED": return .StatusGreen
        
    case "CANCELLED": return .Danger
        
    case "REJECTED": return .Danger
    case "APPROVAL_ORDER": return .Warning
        
    case "PENDING_SHIPPING": return .InvUse
    case "SHIPPING": return .Secondary
        
    case "RECEIVED": return .StatusPurple
    default: return .gray.opacity(0.6)
    }
}

func statusBdColor(_ status: String) -> Color {
    switch status {
    case "ORDER_COMPLETED": return .StatusGreenBg
        
    case "FAILED": return .DangerBg
    case "PAY_COMPLETED": return .StatusGreenBg
        
    case "CANCELLED": return .DangerBg
        
    case "REJECTED": return .DangerBg
    case "APPROVAL_ORDER": return .WarningBg
        
    case "PENDING_SHIPPING": return .InvUseBg
    case "SHIPPING": return .LightBlue04
        
    case "RECEIVED": return .StatusPurpleBg
    default: return .gray.opacity(0.6)
    }
}

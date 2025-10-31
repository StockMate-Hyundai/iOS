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

                   
                    VStack(alignment: .leading, spacing: 6) {
                        Text(formatDate(order.createdAt))
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.bottom, 4)
                        
                        // ✅ 주문 정보
                        HStack(alignment: .top, spacing: 6){
                            VStack(alignment: .leading){
                                Text("주문번호")
                                    .font(.system(size: 14))
                                    .padding(.bottom, 4)
                                
                                Text("상태")
                                    .font(.system(size: 14))
                            }
                            
                            VStack(alignment: .leading){
                                Text(order.orderNumber)
                                    .font(.system(size: 14))
                                
                                Text(statusText(order.orderStatus))
                                    .font(.system(size: 13, weight: .semibold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(statusBdColor(order.orderStatus))
                                    .foregroundColor(statusColor(order.orderStatus))
                                    .cornerRadius(12)
                            }.padding(.leading)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // ✅ 이거 추가
                    .padding(.all, 20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 3, y: 2)


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
                        
                        infoRow("요청사항", order.etc ?? "")
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
                           order.orderStatus == "PAY_COMPLETED" ||
                           order.orderStatus == "PENDING_APPROVAL" {
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
                           
                        } else if order.orderStatus == "PENDING_RECEIVING" ||
                                    order.orderStatus == "DELIVERED"  {
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
    //6 -> 전체 회색
    //4 -> 전체 파란색
    switch status {
    case "ORDER_COMPLETED": return 0    // 주문 완료
    case "PAY_COMPLETED": return 0      // 결제 완료
    case "PENDING_APPROVAL": return 1   // 승인 대기
    case "FAILED": return 6             // 결제 실패
    case "PENDING_SHIPPING": return 2   // 출고 대기
    case "SHIPPING": return 3           // 배송중
    case "PENDING_RECEIVING": return 4  // 입고 대기
    case "REJECTED": return 6           // 승인 반려
    case "DELIVERED": return 4          // 배송 완료
    case "RECEIVED": return 4           // 입고 완료
    case "REFUNDED": return 6           // 환불 완료
    case "REFUND_REJECTED": return 6    // 환불 반려
    case "CANCELLED": return 6          // 주문 취소
    default: return 6
    }
}

func formatDate(_ isoDate: String) -> String {
    let comps = isoDate.split(separator: "T").first?.split(separator: "-") ?? []
    guard comps.count == 3 else { return isoDate }
    return "\(comps[0])년 \(comps[1])월 \(comps[2])일"
}

func statusText(_ status: String) -> String {
    switch status {
    case "ORDER_COMPLETED": return "주문 완료"      // 주문 완료
    case "PAY_COMPLETED": return "결제 완료"        // 결제 완료
    case "PENDING_APPROVAL": return "승인 대기"     // 승인대기
    case "FAILED": return "결제 실패"               // 결제 실패
    case "PENDING_SHIPPING": return "출고 대기"     // 출고 대기
    case "SHIPPING": return "배송중"               // 배송중
    case "PENDING_RECEIVING": return "배송 완료"    // 입고대기
    case "REJECTED": return "승인 반려"             // 이론상 출고 반려
    case "DELIVERED": return "배송 완료"            // 배송 완료
    case "RECEIVED": return "입고 완료"             // 입고 완료
    case "REFUNDED": return "환불 완료"             // 환불 완료
    case "REFUND_REJECTED": return "환불 반려"      // 환불 반려
    case "CANCELLED": return "주문 취소"            // 주문 취소
    default: return "알 수 없음"
    }
}

func statusColor(_ status: String) -> Color {
    switch status {
    case "ORDER_COMPLETED": return .StatusGreen
    case "PAY_COMPLETED": return .StatusGreen
    case "PENDING_APPROVAL": return .Warning
    case "FAILED": return .Danger
    case "PENDING_SHIPPING": return .InvUse
    case "SHIPPING": return .Transfer
    case "PENDING_RECEIVING": return .Secondary
    case "REJECTED": return .Danger
    case "DELIVERED": return .Secondary
    case "RECEIVED": return .StatusPurple
    case "REFUNDED": return .Gray
    case "REFUND_REJECTED": return .Gray
    case "CANCELLED": return .Gray
    default: return .gray.opacity(0.6)
    }
}

func statusBdColor(_ status: String) -> Color {
    switch status {
    case "ORDER_COMPLETED": return .StatusGreenBg
    case "PAY_COMPLETED": return .StatusGreenBg
    case "PENDING_APPROVAL": return .WarningBg
    case "FAILED": return .DangerBg
    case "PENDING_SHIPPING": return .InvUseBg
    case "SHIPPING": return .TransferBg
    case "PENDING_RECEIVING": return .LightBlue04
    case "REJECTED": return .DangerBg
    case "DELIVERED": return .LightBlue04
    case "RECEIVED": return .StatusPurpleBg
    case "REFUNDED": return Color(hex: "#EEEEEF")
    case "REFUND_REJECTED": return Color(hex: "#EEEEEF")
    case "CANCELLED": return Color(hex: "#EEEEEF")
    default: return .gray.opacity(0.6)
    }
}

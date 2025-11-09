//
//  DeliveryStatusView.swift
//  StockMate
//
//  Created by Admin on 10/30/25.
//

import SwiftUI

struct DeliveryStep {
    let title: String
    let iconName: String // Asset 이름
}


struct DeliveryStatusView: View {
    let steps: [DeliveryStep] = [
        DeliveryStep(title: "결제완료", iconName: "check"),
        DeliveryStep(title: "상품준비중", iconName: "uploadprogress"),
        DeliveryStep(title: "배송시작", iconName: "flag"),
        DeliveryStep(title: "배송중", iconName: "rocket"),
        DeliveryStep(title: "배송완료", iconName: "pindrop")
    ]

    let currentStep: Int

    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .center, spacing: 4) {
                ForEach(0..<steps.count, id: \.self) { index in
                    let step = steps[index]
                    let isAllGray = currentStep == 6
                    let isCompleted = !isAllGray && index <= currentStep

                    ZStack {
                        VStack(spacing: 8) {
                            Spacer(minLength: 0) // 위쪽 여백 확보
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(isCompleted ? Color.Primary : Color.gray.opacity(0.2))
//                                    .strokeBorder(isCompleted ? .clear : Color.gray.opacity(0.4), lineWidth: 1.5)
//                                    .background(
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(isCompleted ? Color.Primary : Color.white)
//                                    )
                                    .frame(width: 40, height: 40)
                                
                                Image(step.iconName)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(isCompleted ? .white : (isAllGray ? .gray.opacity(0.6) : .gray.opacity(0.6)))
                            }
                            Text(step.title)
                                .font(.system(size: 11))
                                .foregroundColor(isAllGray ? .gray : (isCompleted ? .black : .gray))
                            Spacer(minLength: 0) // 아래쪽 여백 확보
                        }

                        // 선 연결
                        if index < steps.count - 1 {
                            HStack(spacing: 0) {
                                Spacer()
                                if isAllGray {
                                    Image("dline")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray.opacity(0.2))
                                        .frame(width: 32, height: 3)
                                        .offset(x: 18)
//                                        .frame(width: 42, height: 4)
//                                        .offset(x: 21)

                                } else if index < currentStep {
                                    Rectangle()
                                        .fill(Color.Primary)
                                        .frame(width: 42, height: 3)
                                        .offset(x: 22)
                                } else if index == currentStep {
                                    Image("dline")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color.Primary)
                                        .frame(width: 32, height: 3)
                                        .offset(x: 18)
//                                        .frame(width: 38, height: 3)
//                                        .offset(x: 21)
                                } else {
                                    Image("dline")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray.opacity(0.2))
                                        .frame(width: 32, height: 3)
                                        .offset(x: 18)
//                                        .frame(width: 42, height: 4)
//                                        .offset(x: 21)
                                }
                            }
                            .offset(y: -10) // 선이 정확히 중앙에 오도록 조정
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: 80)
//        .padding(.horizontal, 20) // ✅ 전체 섹션 동일 여백
//        .padding(.vertical, 16)
//        .background(Color.white)
//        .clipShape(RoundedRectangle(cornerRadius: 16)) // 박스 모서리 잘림 방지
//        .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
    }
}


#Preview {
    DeliveryStatusView(currentStep: deliveryStep(for: "APPROVAL_ORDER"))
}

//    // 6 -> 전체 회색
//// 4 -> 전체 파란색
//switch status {
//case "ORDER_COMPLETED": return 0    // 주문 완료
//    
//// 결제 후 결과에 따라 결제 실패 or 완료
//case "FAILED": return 6             // 결제 실패
//case "PAY_COMPLETED": return 0      // 결제 완료
//    
//// 결제 완료 상태에서 지점이 주문 취소
//case "CANCELLED": return 6          // 주문 취소
//    
//// 본사에서 "결제 완료"에 대해서 주문을 반려 or 승인
//case "REJECTED": return 6           // 주문 반려
//case "APPROVAL_ORDER": return 1     // 주문 승인
//
//// 창고관리자가 "주문 승인"에 대해서 송장(인보이스)를 뽑으면 출고 대기
//case "PENDING_SHIPPING": return 2   // 출고 대기
//
//// 창고관리자가 QR을 스캔하여 출고처리 하면 배송중
//case "SHIPPING": return 3           // 배송중
//
//// 지점에서 QR을 스캔하여 입고 완료 처리
//case "RECEIVED": return 4          // 입고 완료

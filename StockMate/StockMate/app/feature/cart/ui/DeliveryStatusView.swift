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
        DeliveryStep(title: "승인대기중", iconName: "hourglass"),
        DeliveryStep(title: "상품준비중", iconName: "uploadprogress"),
        DeliveryStep(title: "배송중", iconName: "rocket"),
        DeliveryStep(title: "배송완료", iconName: "pindrop")
    ]

    let currentStep: Int

    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .center, spacing: 0) {
                ForEach(0..<steps.count, id: \.self) { index in
                    let step = steps[index]
                    let isAllGray = currentStep == 6
                    let isCompleted = !isAllGray && index <= currentStep

                    ZStack {
                        VStack(spacing: 8) {
                            Spacer(minLength: 0) // 위쪽 여백 확보
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(isCompleted ? .clear : Color.gray.opacity(0.4), lineWidth: 1.5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(isCompleted ? Color.Primary : .white)
                                    )
                                    .frame(width: 40, height: 40)
                                
                                Image(step.iconName)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(isCompleted ? .white : (isAllGray ? .gray : .gray))
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
                                    Image("dottedline")
                                        .renderingMode(.template)
                                        .foregroundColor(.gray)
                                        .frame(width: 42, height: 4)
                                        .offset(x: 21)
                                } else if index < currentStep {
                                    Rectangle()
                                        .fill(Color.Primary)
                                        .frame(width: 42, height: 4)
                                        .offset(x: 22)
                                } else if index == currentStep {
                                    Image("dottedline")
                                        .renderingMode(.template)
                                        .foregroundColor(Color.Primary)
                                        .frame(width: 42, height: 4)
                                        .offset(x: 21)
                                } else {
                                    Image("dottedline")
                                        .renderingMode(.template)
                                        .foregroundColor(.gray)
                                        .frame(width: 42, height: 4)
                                        .offset(x: 21)
                                }
                            }
                            .offset(y: -10) // 선이 정확히 중앙에 오도록 조정
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: 90)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16)) // 박스 모서리 잘림 방지
        .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
    }
}


#Preview {
    DeliveryStatusView(currentStep: deliveryStep(for: "REFUND_REJECTED"))
}

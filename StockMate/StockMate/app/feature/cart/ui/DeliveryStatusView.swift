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
                                } else {
                                    Image("dline")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray.opacity(0.2))
                                        .frame(width: 32, height: 3)
                                        .offset(x: 18)
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
    }
}


#Preview {
    DeliveryStatusView(currentStep: deliveryStep(for: "APPROVAL_ORDER"))
}

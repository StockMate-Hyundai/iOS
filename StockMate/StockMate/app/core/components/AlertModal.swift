//
//  AlertModal.swift
//  StockMate
//
//  Created by Admin on 11/4/25.
//


import SwiftUI

struct AlertModal: View {
    var icon: Image? = nil // ✅ 아이콘 없을 수도 있음
    var title: String
    var message: String? = nil
    
    var primaryButtonTitle: String
    var primaryAction: () -> Void
    
    var secondaryButtonTitle: String? = nil
    var secondaryAction: (() -> Void)? = nil
    
    var buttonLayout: ButtonLayout = .vertical // ✅ horizontal / vertical
    
    enum ButtonLayout {
        case vertical
        case horizontal
    }
    
    var body: some View {
        VStack(spacing: 15) {
            if let icon = icon {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top, 6)
            }
            
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            if let message = message {
                Text(message)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 6)
            }
            
            if buttonLayout == .vertical {
                VStack(spacing: 10) {
                    if let secondary = secondaryButtonTitle, let secondaryAction = secondaryAction {
                        Button(secondary, action: secondaryAction)
                            .buttonStyle(CustomButtonStyle(type: .outlined(.Primary)))
                    }
                    Button(primaryButtonTitle, action: primaryAction)
                        .buttonStyle(CustomButtonStyle(type: .filled(Color.Primary)))
                }
            } else {
                HStack(spacing: 10) {
                    if let secondary = secondaryButtonTitle, let secondaryAction = secondaryAction {
                        Button(secondary, action: secondaryAction)
                            .buttonStyle(CustomButtonStyle(type: .outlined(.Primary)))
                    }
                    Button(primaryButtonTitle, action: primaryAction)
                        .buttonStyle(CustomButtonStyle(type: .filled(Color.Primary)))
                }
            }
        }
        .padding(20)
        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(32)
        .shadow(radius: 8)
    }
}

import SwiftUI

#Preview {
    ScrollView{
        VStack(spacing: 40) {
            // ✅ 1. 체크 아이콘 + 버튼 1개
            AlertModal(
                icon: Image("SuccessIllust"),
                title: "등록 완료!",
                message: "입고 부품 등록이 완료되었습니다.",
                primaryButtonTitle: "확인",
                primaryAction: {}
            )
            AlertModal(
                icon: Image("SuccessIllust"),
                title: "출고 완료!",
                message: "사용 처리가 완료되었습니다.",
                primaryButtonTitle: "확인",
                primaryAction: {}
            )
            
            
            
            // ✅ 2. 아이콘 없이 버튼 2개 (가로)
            AlertModal(
                title: "주문 취소",
                message: "주문을 취소하시겠습니까?",
                primaryButtonTitle: "예",
                primaryAction: {},
                secondaryButtonTitle: "아니오",
                secondaryAction: {},
                buttonLayout: .horizontal
            )
            AlertModal(
                title: "로그아웃",
                message: "로그아웃 하시겠습니까?",
                primaryButtonTitle: "로그아웃",
                primaryAction: {},
                secondaryButtonTitle: "취소",
                secondaryAction: {},
                buttonLayout: .horizontal
            )
            
            
            // ✅ 3. 주문완료
            AlertModal(
                icon: Image("SuccessIllust"),
                title: "주문완료!",
                message: "해당 부품 주문이 완료되었습니다.",
                primaryButtonTitle: "주문상세",
                primaryAction: {},
                secondaryButtonTitle: "홈으로",
                secondaryAction: {},
                buttonLayout: .vertical
            )
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
   
}

//
//  AlertModal.swift
//  StockMate
//
//  Created by Admin on 11/4/25.
//

import SwiftUI


// 공용 알림 모달 뷰
// 아이콘, 제목, 메시지, 버튼 구성에 따라 다양한 형태로 표시 가능
struct AlertModal: View {
    var icon: Image? = nil
    var title: String
    var message: String? = nil
    
    // 주요 버튼 텍스트 및 동작
    var primaryButtonTitle: String
    var primaryAction: () -> Void
    
    // 보조 버튼 텍스트 및 동작 (선택)
    var secondaryButtonTitle: String? = nil
    var secondaryAction: (() -> Void)? = nil
    
    // 버튼 배치 방향 설정 (세로 / 가로)
    var buttonLayout: ButtonLayout = .vertical
    
    // 버튼 레이아웃 타입 정의
    enum ButtonLayout {
        case vertical
        case horizontal
    }
    
    var body: some View {
        VStack(spacing: 15) {
            // 아이콘이 있을 경우 표시
            if let icon = icon {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top, 6)
            }
            // 제목 텍스트
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            // 메시지 텍스트가 있을 경우 표시
            if let message = message {
                Text(message)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 6)
            }
            
            // 버튼 레이아웃에 따라 분기
            if buttonLayout == .vertical {
                // 세로 방향 버튼 배치
                VStack(spacing: 10) {
                    if let secondary = secondaryButtonTitle, let secondaryAction = secondaryAction {
                        Button(secondary, action: secondaryAction)
                            .buttonStyle(
                                CustomButtonStyle(type: .outlined(.Primary))
                            )
                    }
                    Button(primaryButtonTitle, action: primaryAction)
                        .buttonStyle(
                            CustomButtonStyle(type: .filled(Color.Primary))
                        )
                }
            } else {
                // 가로 방향 버튼 배치
                HStack(spacing: 10) {
                    if let secondary = secondaryButtonTitle, let secondaryAction = secondaryAction {
                        Button(secondary, action: secondaryAction)
                            .buttonStyle(
                                CustomButtonStyle(type: .outlined(.Primary))
                            )
                    }
                    Button(primaryButtonTitle, action: primaryAction)
                        .buttonStyle(
                            CustomButtonStyle(type: .filled(Color.Primary))
                        )
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
            // 체크 아이콘 + 버튼 1개
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
            
            // 아이콘 없이 버튼 2개 (가로 배치)
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
            
            // 주문 완료 알림 (세로 버튼 배치)
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

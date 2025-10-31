//
//  ReceiptView.swift
//  StockMate
//
//  Created by Admin on 10/28/25.
//

import SwiftUI
import PDFKit
import UIKit

enum PDFType {
    case a4
    case receipt80mm
}

struct ReceiptView: View {
    let orderId: Int
    
    @StateObject private var detailViewModel = OrderDetailViewModel()
    
    @State var sellerName = "홍길동"
    @State var businessNumber = "215-87-12345"  // 형식만 맞춘 랜덤번호
    @State var phone = "02-567-8901"
    @State var address = "서울특별시 금천구 가산동 459-9"

    
    var body: some View {
        ScrollView {
            if detailViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let order = detailViewModel.order {
                VStack(alignment: .leading) {
                    receiptContent(order: order)
                    
                    Button {
                        generatePDF(type: .receipt80mm, order: order)
                    } label: {
                        Text("영수증 PDF 저장")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)

                }
                .background(Color.white)
                .cornerRadius(12)
                .padding()
            }
        }
        .background(Color.Light)
        .navigationTitle("영수증")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await detailViewModel.fetchOrderDetail(orderId: orderId)
        }

    }
    
    private func receiptContent(order: OrderResponseItem) -> some View {
        let total = order.totalPrice
        let vat = Int(Double(total) * 10 / 110) // 부가세액
        let supplyPrice = total - vat           // 공급가액
        
        return VStack(alignment: .leading, spacing: 16) {
            section("결제 정보") {
                Divider()
                if order.paymentType == "DEPOSIT" {
                    row("거래종류", "예치금")
                } else {
                    row("결제수단", "신용카드")
                }
                row("승인번호", formattedApprovalNumber(order.createdAt))
                row("거래일시", formattedDate(order.createdAt))

            }
            .padding(4)
            .padding(.top,5)

            section("구매정보") {
                Divider()
                VStack(spacing: 8){
                    row("주문번호", order.orderNumber)
                    VStack{
                        // 상품명 라벨과 첫 번째 상품 같은 라인
                        if let first = order.orderItems.first {
                            HStack {
                                Text("상품명")
                                Spacer()
                                Text("\(first.partDetail.korName) \(first.amount)개")
                            }
                        }
                        // 나머지는 label 없이 아래에
                        ForEach(order.orderItems.dropFirst(), id: \.partId) { item in
                            HStack {
                                Spacer() // label 영역만큼 들여쓰기 효과
                                Text("\(item.partDetail.korName) \(item.amount)개")
                            }
                        }
                    }
                    row("공급가액", "\(formatPrice(supplyPrice))원")
                    row("부가세액", "\(formatPrice(vat))원")
                    row("합계금액", "\(formatPrice(total))원", highlight: true)
                }
            }
            .padding(4)
            .padding(.top)

            section("판매자 정보") {
                Divider()
                row("대표자명", sellerName)
                row("사업자등록번호", businessNumber)
                row("전화번호", phone)
                row("사업장주소", address)
            }
            .padding(4)
            .padding(.top)

            Divider()
            
            Text("""
            • 비현금성으로 지급되는 예치금 사용 금액의 경우 현금 영수증 발행 대상에서
              제외될 수 있습니다.
            • 발생 정보는 구매확정 또는 거래 완료 이후 전달되기 때문에 국세청 사이트에서
              즉시 확인되지 않을 수 있습니다.
            • 이 영수증은 조세특례제한법 제 126조 3항에 의거 연말정산 시 소득공제혜택
              부여 목적으로 발행됩니다. (국세청 회원가입 필수)
            • 현금 영수증은 구매확정 또는 거래 완료 후 48시간 내로 국세청에서 확인 작업 
              후 최종 확정됩니다.
            • 국세청 확인: 홈택스 홈페이지(https://www.hometax.go.kr/) 또는 국세청
              상담센터(현금영수증 문의 ☎️126-1-1)
            """)
            .font(.system(size: 10.5))
            .foregroundColor(.textGray1)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineSpacing(4)
            .padding(.leading, 2) // 문장 들여쓰기 추가

        }
        .padding()
    }

    private func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            content()
        }
        .font(.subheadline)
    }

    private func row(_ key: String, _ value: String, highlight: Bool = false) -> some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
                .fontWeight(highlight ? .bold : .regular)
                .foregroundColor(highlight ? .blue : .primary)
        }
    }

    private func generatePDF(type: PDFType, order: OrderResponseItem) {
        let view = receiptContent(order: order) // ✅ 실제 View 생성
        let renderer = ImageRenderer(content: view)

        let width: CGFloat
        switch type {
            case .a4: width = 595.2  // A4 width in pt
            case .receipt80mm: width = 226.77 // 80mm in pt
        }

        renderer.scale = UIScreen.main.scale
        
        // ✅ cgImage 기반 안전 처리
         if let cgImage = renderer.cgImage {
             let uiImage = UIImage(cgImage: cgImage)
             let pdfDoc = PDFDocument()
             if let pdfPage = PDFPage(image: uiImage) {
                 pdfDoc.insert(pdfPage, at: 0)
             }

             // ✅ 주문번호 기반 파일명
             let fileName = "receipt_\(order.orderNumber).pdf"
             let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

             if pdfDoc.write(to: tempURL) {
                 let av = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)

                 if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let rootVC = windowScene.windows.first?.rootViewController {
                     av.popoverPresentationController?.sourceView = rootVC.view
                     rootVC.present(av, animated: true)
                 }
             }
         }
        
    }
}

//struct ReceiptView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReceiptView()
//    }
//}

func formattedDate(_ timestamp: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.locale = Locale(identifier: "ko_KR")
    inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

    guard let date = inputFormatter.date(from: timestamp) else {
        return timestamp
    }

    let outputFormatter = DateFormatter()
    outputFormatter.locale = Locale(identifier: "ko_KR")
    outputFormatter.timeZone = TimeZone.current
    outputFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

    return outputFormatter.string(from: date)
}

func formattedApprovalNumber(_ timestamp: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.locale = Locale(identifier: "ko_KR")
    inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

    guard let date = inputFormatter.date(from: timestamp) else {
        return timestamp
    }

    let outputFormatter = DateFormatter()
    outputFormatter.locale = Locale(identifier: "ko_KR")
    outputFormatter.timeZone = TimeZone.current
    outputFormatter.dateFormat = "yyyyMMddHHmm" // ✅ 승인번호 포맷

    return outputFormatter.string(from: date)
}

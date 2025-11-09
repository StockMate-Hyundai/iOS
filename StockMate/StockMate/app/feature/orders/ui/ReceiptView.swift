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
    @Environment(\.dismiss) private var dismiss
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
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom,4)
                
                Button {
                    generatePDF(type: .receipt80mm, order: order)
                } label: {
                    Text("PDF 저장")
                        .font(.system(size: 13, weight: .semibold)) // ✅ 글씨 약간 작게
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .background(Color.Primary)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(Color.Light)
        .navigationTitle("영수증")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(.black)
                }
            }
        }
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
            
            NoticeTextView()
                .padding(.top, 4)

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
                .foregroundColor(highlight ? .Primary : .primary)
        }
    }

    private func generatePDF(type: PDFType, order: OrderResponseItem) {
        // ✅ 아이폰 화면 비율로 렌더링 (디바이스 폭 고정)
        let screenWidth = UIScreen.main.bounds.width
        let view = receiptContent(order: order)
            .frame(width: screenWidth) // 폭 고정 (문장 길이에 따라 늘어나지 않음)
            .background(Color.white)

        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale

        if let cgImage = renderer.cgImage {
            let uiImage = UIImage(cgImage: cgImage)
            let pdfDoc = PDFDocument()
            if let pdfPage = PDFPage(image: uiImage) {
                pdfDoc.insert(pdfPage, at: 0)
            }

            // ✅ 파일명: 주문번호 기반
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

func formattedDate(_ timestamp: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.locale = Locale(identifier: "ko_KR")
    inputFormatter.timeZone = TimeZone.current // ✅ 실제 한국 시간 기준
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

struct NoticeTextView: View {
    let notices = [
        "본 영수증은 거래완료 후 국세청 반영까지 시간이 소요될 수 있습니다.",
        "현금영수증/지출증빙 여부는 국세청 홈페이지 또는 상담센터(126)에서 확인하세요.",
        "비현금성으로 지급되는 포인트로 결제한 금액은 현금영수증 발행 대상에서 제외될 수 있습니다.",
        "발행 방법이 자진 발급인 경우 국세청 사이트에서 자진발급분을 사용자 등록 후 소득공제 등 혜택을 받으실 수 있습니다.",
        "발행 정보는 구매확정 또는 거래 완료 후 전달되며, 국세청 사이트에 즉시 반영되지 않을 수 있습니다.",
        "이 영수증은 조세특례제한법 제126조 3항에 의거, 연말정산 시 소득공제 혜택 부여 목적 등으로 발행됩니다. (국세청 회원가입 필요)",
        "현금 영수증은 구매 확정 또는 거래 완료 후 48시간 내에 국세청에서 확인 작업 후 최종 확정됩니다.",
        "국세청 확인: 홈택스 홈페이지(https://www.hometax.go.kr/) 또는 국세청 상담센터(현금영수증 문의 ☎️126-1-1)."
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(notices, id: \.self) { text in
                HStack(alignment: .top, spacing: 3) {
                    Text("•")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(text)
                        .font(.system(size: 11.5))
                        .foregroundColor(.textGray1)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 2)
    }
}

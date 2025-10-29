//
//  ReceiptView.swift
//  StockMate
//
//  Created by Admin on 10/28/25.
//

import SwiftUI
import PDFKit

enum PDFType {
    case a4
    case receipt80mm
}
// TODO: API 연결 후 주문 상세 페이지와 연결
struct ReceiptView: View {
    
    
    @State var paymentType = "예치금"
    @State var approvalNumber = "202510300743"
    @State var date = "2025/10/30 07:43:54"
    @State var orderNumber = "SMO-2"
    @State var itemName = "배터리-트랜스미터"
    @State var quantity = 1
    @State var price = 5273
    @State var sellerName = "박시영"
    @State var businessNumber = "888777776666"
    @State var phone = "010-2596-2352"
    @State var address = "서울특별시 성동구 동일로 259 3층"

    var vat: Int { Int(Double(price) * 0.1) }
    var total: Int { price + vat }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                receiptContent
                
                HStack {
                    pdfButton(type: .a4, title: "A4 PDF")
                    pdfButton(type: .receipt80mm, title: "영수증 PDF")
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding()
        }
        .background(Color.Light)
        .navigationTitle("영수증")
        .navigationBarTitleDisplayMode(.inline)

    }

    private var receiptContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            section("결제 정보") {
                Divider()
                row("거래종류", paymentType)
                row("승인번호", approvalNumber)
                row("거래일시", date)
            }
            .padding(4)
            .padding(.top,5)

            section("구매정보") {
                Divider()
                row("주문번호", orderNumber)
                row("상품명", "\(itemName), \(quantity)개")
                row("공급가액", "\(price)원")
                row("부가세액", "\(vat)원")
                row("합계금액", "\(total)원", highlight: true)
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
            .padding(.leading, 2) // ✅ 총알 뒤 문장 들여쓰기 추가

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

    private func pdfButton(type: PDFType, title: String) -> some View {
        Button(action: {
            generatePDF(type: type)
        }) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }

    private func generatePDF(type: PDFType) {
        let content = receiptContent
        let renderer = ImageRenderer(content: content)

        let width: CGFloat
        let height: CGFloat = 2000

        switch type {
            case .a4: width = 595.2  // A4 width in pt
            case .receipt80mm: width = 226.77 // 80mm in pt
        }

        renderer.scale = UIScreen.main.scale

        if let image = renderer.uiImage {
            let pdfDoc = PDFDocument()
            let pdfPage = PDFPage(image: image)
            pdfDoc.insert(pdfPage!, at: 0)

            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("receipt.pdf")
            if pdfDoc.write(to: tempURL) {
                let av = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true)
            }
        }
    }
}

struct ReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptView()
    }
}

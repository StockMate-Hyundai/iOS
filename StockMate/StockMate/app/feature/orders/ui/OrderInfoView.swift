//
//  OrderInfoView.swift
//  StockMate
//
//  Created by Admin on 10/20/25.
//
import SwiftUI

enum PaymentType: String {
    case deposit = "DEPOSIT"
    case card = "CARD"
}

enum ShippingDateOption {
    case today
    case tomorrow
    case specific(Date)
}

struct OrderInfoView: View {
    @ObservedObject var cartViewModel: CartViewModel
    @StateObject var orderViewModel = OrderViewModel()
    
    @State private var paymentType: PaymentType = .deposit
    @State private var shippingDateOption: ShippingDateOption = .today
    @State private var specificDate = Date()
    @State private var requestMessage: String = ""
    
    @State private var navigateToSuccessPage = false
    
    private var destinationView: some View {
        Group {
            if let id = orderViewModel.createdOrderId {
                OrderDetailView(orderId: id, orderViewModel: orderViewModel)
            } else {
                EmptyView()
            }
        }
    }
    
    func formattedShippingDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        
        switch shippingDateOption {
        case .today:
            return formatter.string(from: Date())
        case .tomorrow:
            return formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        case .specific(let date):
            return formatter.string(from: date)
        }
    }
    
    func makeOrderItems() -> [OrderItems] {
        return cartViewModel.items.map {
            OrderItems(partId: $0.id, amount: $0.amount)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                contentView
            }
            .padding(.horizontal)
            .padding(.top)
            
            bottomOrderButton
        }
        .background(Color.Light)
        .navigationTitle("주문/결제")
        .navigationBarTitleDisplayMode(.inline)
        .task { await cartViewModel.fetchCart() }
        .edgesIgnoringSafeArea(.bottom)
        .onChange(of: orderViewModel.isOrderSuccess) { success in
            if success {
                Task {
                    await cartViewModel.clearCart()
                    navigateToSuccessPage = true
                }
            }
        }
    }
}

// MARK: - UI 구성 View
extension OrderInfoView {
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 10) {
            shippingInfoSection
            orderListSection
            paymentSection
            shippingDateSection
            totalPriceSection
        }
    }
    
    private var shippingInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("배송 정보")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("홍길동").font(.system(size: 15, weight: .medium))
                Text("서울특별시 강남구 테헤란로114길")
                    .font(.system(size: 14))
                    .foregroundColor(.textGray1)
                Text("010-1111-2222")
                    .font(.system(size: 14))
                    .foregroundColor(.textGray1)
                
                Text("요청사항")
                    .font(.system(size: 14, weight: .medium))
                    .padding(.top, 5)
                
                ZStack(alignment: .topLeading) {
                    if requestMessage.isEmpty {
                        Text("요청사항을 입력하세요")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                            .padding(.top, 12)
                            .padding(.leading, 10)
                    }
                    
                    TextEditor(text: $requestMessage)
                        .font(.system(size: 14))
                        .padding(.top, 4)
                        .padding(.leading, 6)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                }
                .frame(height: 70)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray4), lineWidth: 1))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
        }
        .padding(.leading, 5)
    }
    
    private var orderListSection: some View {
        VStack(alignment: .leading) {
            Text("주문 목록")
                .font(.headline)
                .padding(.leading, 5)
            
            Section {
                LazyVStack(spacing: 8) {
                    ForEach(cartViewModel.items) { cartItem in
                        CartInfoCard(item: cartItem, quantity: cartItem.amount)
                            .padding(.horizontal, 5)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(16)
        }
    }
    
    private var paymentSection: some View {
        VStack(alignment: .leading) {
            Text("결제 수단")
                .font(.headline)
                .padding(.leading, 5)
            
            VStack(alignment: .leading, spacing: 5) {
                RadioButtonRow(title: "예치금 (잔액 ₩1,200,000)", selected: paymentType == .deposit) {
                    paymentType = .deposit
                }
                RadioButtonRow(title: "직접 결제", selected: paymentType == .card) {
                    paymentType = .card
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(16)
        }
    }
    
    private var shippingDateSection: some View {
        VStack(alignment: .leading) {
            Text("배송 요청일")
                .font(.headline)
                .padding(.leading, 5)
            
            VStack(alignment: .leading, spacing: 5) {
                RadioButtonRow(title: "오늘", selected: {
                    if case .today = shippingDateOption { return true }
                    return false
                }()) {
                    shippingDateOption = .today
                }
                
                RadioButtonRow(title: "내일", selected: {
                    if case .tomorrow = shippingDateOption { return true }
                    return false
                }()) {
                    shippingDateOption = .tomorrow
                }
                
                HStack {
                    RadioButtonRow(title: "날짜 선택", selected: {
                        if case .specific(_) = shippingDateOption { return true }
                        return false
                    }()) {
                        shippingDateOption = .specific(specificDate)
                    }
                    
                    if case .specific(_) = shippingDateOption {
                        CustomDatePickerField(date: Binding {
                            specificDate
                        } set: { newValue in
                            specificDate = newValue
                            shippingDateOption = .specific(newValue)
                        })
                    }
                }
                .frame(height: 35)
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
        }
    }
    
    private var totalPriceSection: some View {
        HStack {
            Text("결제금액")
                .font(.system(size: 16, weight: .semibold))
            Spacer()
            Text("\(cartViewModel.cart?.totalPrice ?? 0)원")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.Primary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var bottomOrderButton: some View {
        VStack {
            Button {
                Task {
                    let orderRequest = OrderRequest(
                        orderItems: makeOrderItems(),
                        requestedShippingDate: formattedShippingDate(),
                        paymentType: paymentType.rawValue,
                        etc: requestMessage
                    )
                    await orderViewModel.createOrder(request: orderRequest)
                }
            } label: {
                Text("결제하기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background(Color.Primary)
            }
            
            NavigationLink(destination: destinationView, isActive: $navigateToSuccessPage) {
                EmptyView()
            }
        }
    }
}

struct RadioButtonRow: View {
    let title: String
    var selected: Bool
    var action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: selected ? "circle.inset.filled" : "circle")
                .foregroundColor(selected ? .Primary : .gray)
            Text(title)
            //            Spacer()
        }
        .onTapGesture { action() }
    }
}


struct CustomDatePickerField: View {
    @Binding var date: Date
    @State private var showPicker: Bool = false
    
    // 날짜 포맷 변환용 Formatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var body: some View {
        Button {
            showPicker.toggle()
        } label: {
            HStack {
                Text(dateFormatter.string(from: date))
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
            }
            .padding(10)
            .frame(width: 140, height: 30)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(.systemGray4))
            )
        }
        .sheet(isPresented: $showPicker) {
            VStack {
                DatePicker(
                    "",
                    selection: $date,
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Button("완료") {
                    showPicker = false
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
            }
            .presentationDetents([.medium])
        }
    }
}


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
    case specific(Date?)
}

struct OrderInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var cartViewModel: CartViewModel
    @StateObject var orderViewModel = OrderViewModel()
    @StateObject private var depositViewModel = DepositViewModel()
    @StateObject private var userViewModel = UserViewModel()
    
    @State private var paymentType: PaymentType = .deposit
    @State private var shippingDateOption: ShippingDateOption = .today
    @State private var specificDate: Date? = nil
    @State private var requestMessage: String = ""
    
    // 토스트 메세지 관련
    @State private var showDepositToast = false      // 예치금 부족
    @State private var showChargeToast = false       // 충전 완료


    // ✅ 모달 관련 상태
    @State private var showOrderSuccessModal = false
    @State private var navigateToOrderDetail = false
    @State private var navigateToHome = false
    
    private var destinationView: some View {
       Group {
           if navigateToOrderDetail, let id = orderViewModel.createdOrderId {
               OrderDetailView(orderId: id, orderViewModel: orderViewModel)
           } else if navigateToHome {
               HomeView()
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
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            return formatter.string(from: tomorrow)
        case .specific(let date):
            return formatter.string(from: date ?? Date())       // nil이면 오늘 날짜로 fallback
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
            .onTapGesture {
                UIApplication.shared.hideKeyboard() // 화면 아무데나 탭하면 키보드 내려감
            }
            .padding(.horizontal)
            .padding(.top)
            
            bottomOrderButton
        }
        .toast(
            isPresented: $showChargeToast,
            message: "충전이 완료되었습니다.",
            iconName: "checkmark",
            iconColor: .green
        )
        // ✅ 예치금 부족 토스트
       .toast(
           isPresented: $showDepositToast,
           message: "예치금이 부족합니다. (부족: \(formatPrice((cartViewModel.cart?.totalPrice ?? 0) - depositViewModel.balance))원)",
           iconName: "info.circle",
           iconColor: .LightBlue04
       )
        .background(Color.Light)
        .navigationTitle("주문/결제")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .task {
            await cartViewModel.fetchCart()
            await depositViewModel.fetchDepositAmount()
            await userViewModel.loadUserInfo()
            
        }
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
        .edgesIgnoringSafeArea(.bottom)
        .onChange(of: orderViewModel.isOrderSuccess) { success in
            if success {
                Task {
                    // 1) 서버에 반영된 장바구니를 먼저 비운다 (await)
                    await cartViewModel.clearCart()
                    // 2) cart가 비워진 후에 모달을 띄운다
                    // (모달을 띄우기 전에 createdOrderId는 orderViewModel에 이미 세팅되어 있어야 함)
                    showOrderSuccessModal = true
                }
            }
        }
        .sheet(isPresented: $depositViewModel.showChargeSheet) {
            DepositChargeView(viewModel: depositViewModel) {
                // ✅ 충전 성공 시 토스트 표시
                withAnimation {
                    showChargeToast = true
                }
            }
            .presentationDetents([.fraction(0.58)]) // 시트 높이 80%
            .presentationCornerRadius(20)
        }
        // 모달 오버레이 (body 안)
        .overlay {
            if showOrderSuccessModal {
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea()
                        .onTapGesture {
                            // 배경 탭으로도 모달 닫을 수 있게 하려면 uncomment
                            // showOrderSuccessModal = false
                        }

                    AlertModal(
                        icon: Image("SuccessIllust"),
                        title: "주문완료!",
                        message: "해당 부품 주문이 완료되었습니다.",
                        primaryButtonTitle: "주문상세",
                        primaryAction: {
                            // 1) 모달 닫기
                            showOrderSuccessModal = false

                            // 2) 네비게이션 트리거 -> OrderDetail 로 이동
                            // orderViewModel.createdOrderId 가 있어야 함
                            navigateToOrderDetail = true
                        },
                        secondaryButtonTitle: "홈으로",
                        secondaryAction: {
                            // 모달 닫고 홈으로
                            showOrderSuccessModal = false
                            navigateToHome = true
                        },
                        buttonLayout: .vertical
                    )
                    .transition(.scale)
                    .padding(.horizontal, 20)
                }
                .animation(.easeInOut, value: showOrderSuccessModal)
            }
        }

        // 네비게이션 실행을 위한 숨은 링크 (body 밖 어디든)
        .background(
            Group {
                // OrderDetail 우선 (OrderDetail은 createdOrderId 를 필요로 함)
                NavigationLink(destination:
                                Group {
                                    if let id = orderViewModel.createdOrderId {
                                        OrderDetailView(orderId: id, orderViewModel: orderViewModel)
                                    } else {
                                        EmptyView()
                                    }
                                },
                               isActive: $navigateToOrderDetail) {
                    EmptyView()
                }

                NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                    EmptyView()
                }
            }
        )
    }
        

}

// MARK: - UI 구성 View
extension OrderInfoView {
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 17) {
            shippingInfoSection
            orderListSection
            paymentSection
            shippingDateSection
            totalPriceSection
            
            Spacer().frame(height: 10)
        }
    }
    
    private var shippingInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("배송 정보")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(userViewModel.userInfo?.owner ?? "이름 없음")
                    .font(.system(size: 15, weight: .medium))
                Text(userViewModel.userInfo?.address ?? "주소 없음")
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
                       .padding(.horizontal, 6)
                       .onChange(of: requestMessage) { newValue in
                           if newValue.count > 50 {     // 50자 제한
                               requestMessage = String(newValue.prefix(50))
                           }
                       }
                       .scrollContentBackground(.hidden)
                       .background(Color.clear)
                }
                .frame(height: 70)
                .background(Color.white)
                .overlay(
                   RoundedRectangle(cornerRadius: 10)
                       .stroke(requestMessage.isEmpty ? Color(.systemGray4) : Color.Primary, lineWidth: 1) // ✅ 입력 시 Primary로 변경
                )
                HStack {
                    Spacer()
                    Text("\(requestMessage.count)/50")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.trailing, 4)
                        .padding(.bottom, -15) // 박스보다 살짝 아래로
                }
            }
            .padding()
            .padding(.bottom,7)
            .background(Color.white)
            .cornerRadius(16)
        }
        .padding(.leading, 5)
    }
    
    private var orderListSection: some View {
        VStack(alignment: .leading) {
            Text("주문 목록 (\(cartViewModel.items.count))")
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
        ZStack {
            // 배경 이미지 적용
            Image("deposit_background") // ← 에셋에 넣은 이미지 이름
                .resizable()
                .scaledToFill()
                .frame(height: 190)
                .clipped()
                .cornerRadius(16.39)
            
            VStack(alignment: .leading, spacing: 12) {
                VStack (alignment: .leading, spacing: 13){
                    HStack {
                        Text("사용 가능 예치금")
                            .font(.system(size: 17, weight: .bold))
                            .padding(.leading, 5)
                            .padding(.top, 25)
                            .foregroundColor(Color.white)
                    }
                    
                    HStack {
                        // 예치금 금액 표시
                        if depositViewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("₩\(formatPrice(depositViewModel.balance))")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(Color.white)
                        }
                    }
                }

                Spacer()
                
                HStack {
                    Spacer()
                    Button {
                        depositViewModel.showChargeSheet = true   // <-- $ 없이 할당
                    } label: {
                        Text("충전")
                            .foregroundColor(Color.Primary)
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 14)
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                    .padding(.trailing, 5)
                }
                .padding(.bottom, 25)
            }
            .frame(height: 185)
            .padding(20)
        }
        .frame(maxWidth: .infinity)
    }

    private var shippingDateSection: some View {
        VStack(alignment: .leading) {
            Text("배송 요청일")
                .font(.headline)
                .padding(.leading, 5)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    RadioButtonRow(title: "오늘", selected: {
                        if case .today = shippingDateOption { return true }
                        return false
                    }()) {
                        shippingDateOption = .today
                    }
                    Spacer()
                }
                .frame(height: 35)
                HStack {
                    RadioButtonRow(title: "내일", selected: {
                        if case .tomorrow = shippingDateOption { return true }
                        return false
                    }()) {
                        shippingDateOption = .tomorrow
                    }
                    Spacer()
                }
                .frame(height: 35)
                
                HStack (spacing: 30){
                    RadioButtonRow(title: "날짜 선택", selected: {
                        if case .specific(_) = shippingDateOption { return true }
                        return false
                    }()) {
                        shippingDateOption = .specific(nil)
                    }
                    .padding(.trailing, 5)
                    
                    if case .specific(let selectedDate) = shippingDateOption {
                        CustomDatePickerField(date: Binding(
                            get: { selectedDate ?? Date() },
                            set: { newValue in
                                specificDate = newValue
                                shippingDateOption = .specific(newValue)
                            }
                        ), isDateSelected: selectedDate != nil)
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
               let totalPrice = cartViewModel.cart?.totalPrice ?? 0
               let deposit = depositViewModel.balance
                           
               if totalPrice > deposit {
                   // ✅ 예치금 부족
                   withAnimation {
                       showDepositToast = true
                   }
               } else {
                    Task {
                        let orderRequest = OrderRequest(
                            orderItems: makeOrderItems(),
                            requestedShippingDate: formattedShippingDate(),
                            paymentType: paymentType.rawValue,
                            etc: requestMessage
                        )
                        await orderViewModel.createOrder(request: orderRequest)
                    }
                }
               
            } label: {
                Text("\(cartViewModel.cart?.totalPrice ?? 0)원 결제하기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(cartViewModel.items.isEmpty ? Color.gray.opacity(0.3) : Color.Primary)
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
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
        }
        .onTapGesture { action() }
    }
}

struct CustomDatePickerField: View {
    @Binding var date: Date
    var isDateSelected: Bool
    @State private var showPicker: Bool = false

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
                Text(isDateSelected ? dateFormatter.string(from: date) : "선택하세요")
                    .font(.system(size: 14))
                    .foregroundColor(isDateSelected ? .black : .gray)

                Spacer()

                Image("cal")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .scaledToFit()
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

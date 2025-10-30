import SwiftUI

struct DepositChargeView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DepositViewModel
    @State private var amountText: String = ""
    @State private var isCharging: Bool = false
    
    let keypad: [[String]] = [
        ["1","2","3"],
        ["4","5","6"],
        ["7","8","9"],
        ["00","0","⌫"]
    ]
    
    private var formattedNumberString: String {
        if let value = Int(amountText) {
            return value.formatted(.number)
        }
        return "0"
    }
    
    private var formattedAmount: String {
        return formattedNumberString + "원"
    }

    func buttonAction(_ val: String) {
        if val == "⌫" {
            if !amountText.isEmpty { amountText.removeLast() }
        } else {
            amountText.append(val)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Title
            Text("예치금 충전")
                .font(.system(size: 20, weight: .semibold))
                .padding(.top, 35)
            
            // 금액
            Text(formattedAmount)
                .font(.system(size: 38, weight: .bold))
                .padding(.top, 35)
            
            // 아래 작은 라벨
//            Text("\(formattedNumberString)원")
//                .font(.system(size: 15))
//                .foregroundColor(.textGray1)
//                .padding(.horizontal, 10)
//                .padding(.vertical, 4)
//                .background(Color.white.opacity(0.9))
//                .cornerRadius(12)
            
            Spacer().frame(height: 80)
            
            // 키패드
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3),
                      spacing: 1) {
                ForEach(keypad.flatMap { $0 }, id: \.self) { key in
                    Button {
                        buttonAction(key)
                    } label: {
                        Text(key)
                            .font(.system(size: 20))
                            .frame(width: 50, height: 45)
                            .foregroundColor(Color.black)
//                            .background(Color.red.opacity(0.5))
                            .padding(.horizontal, 4)
                            .background(Color.white)
                    }
                }
            }
            .padding(.horizontal,16)
            .padding(.top, 28)
            
            
            // 충전 버튼
            Button {
                Task {
                    guard let amount = Int(amountText), amount > 0 else { return }
                    isCharging = true
                    let success = await viewModel.chargeDeposit(amount: amount)
                    isCharging = false
                    if success {
                        viewModel.showChargeSheet = false
                        dismiss()
                    }
                }
            } label: {
                if isCharging {
                    ProgressView()
                        .tint(.white)
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                } else {
                    Text("충전")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(height: 59)
                        .frame(maxWidth: .infinity)
                }
            }
            .background(Color.Primary)
            .cornerRadius(28)
            .padding(.top, 28)
            .padding(.horizontal, 10)
        }
        .padding(.horizontal, 20)
//        .padding(.top, 20)
        .background(Color.white)
    }
}

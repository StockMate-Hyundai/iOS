import SwiftUI

struct DepositChargeView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DepositViewModel
    @State private var amountText: String = ""
    @State private var isCharging: Bool = false
    
    var onChargeSuccess: (() -> Void)?

    
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
                .font(.system(size: 18, weight: .semibold))
                .padding(.top, 42)
            
            // 금액
            Text(formattedAmount)
                .font(.system(size: 32, weight: .bold))
            
            // 키패드
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 11), count: 3),
                      spacing: 16) {
                ForEach(keypad.flatMap { $0 }, id: \.self) { key in
                    Button {
                        buttonAction(key)
                    } label: {
                        if key == "⌫" {
                              Image("backspace")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .frame(width: 60, height: 45)
                                .background(Color.white)
                          } else {
                              Text(key)
                                  .font(.system(size: 19))
                                  .foregroundColor(Color.black)
                                  .frame(width: 60, height: 45)
                                  .background(Color.white)
                          }
                    }
                }
            }
            .padding(.horizontal,16)
            
            
            // 충전 버튼
            Button {
                guard !isCharging else { return }
                Task {
                    guard let amount = Int(amountText), amount > 0 else { return }
                    isCharging = true
                    let success = await viewModel.chargeDeposit(amount: amount)
                    isCharging = false
                    if success {
                        viewModel.showChargeSheet = false
                        dismiss()
                        onChargeSuccess?()
                    } else {
                        
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
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(height: 49)
                        .frame(maxWidth: .infinity)
                }
            }
            .background(
                (Int(amountText) ?? 0) > 0 && !isCharging
                    ? Color.Primary     // ✅ 활성 상태
                    : Color.gray.opacity(0.3)  // ✅ 비활성(회색)
            )
            .cornerRadius(18)
            .padding(.bottom, 25)
            .padding(.horizontal, 10)
            .disabled(isCharging || (Int(amountText) ?? 0) == 0)
        }
        .padding(.horizontal, 20)
        .background(Color.white)
        

    }
}

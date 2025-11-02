//
//  BarChartView.swift
//  StockMate
//
//  Created by Admin on 11/2/25.
//

import SwiftUI

struct BarChartView: View {
    let values: [CGFloat]       // 각 월별 비율값 (0~1)
    let labels: [String]        // 예: ["06", "07", "08", "09", "10"]
    let amounts: [Int]          // 예: [230000, 250000, 310000, 280000, 400000]
    @Binding var selectedMonth: String?

    var body: some View {
        // ✅ 최신월이 오른쪽에 오도록 역순 정렬
        let reversedValues = Array(values.reversed())
        let reversedLabels = Array(labels.reversed())
        let reversedAmounts = Array(amounts.reversed())

        // ✅ "07" → "7월" 형식 변환
        let displayLabels = reversedLabels.map { label in
            if let monthInt = Int(label) {
                return "\(monthInt)월"
            } else {
                return label
            }
        }

        // ✅ 기본 선택: 최신월
        let defaultMonth = displayLabels.first ?? ""
        let activeMonth = selectedMonth ?? defaultMonth

        VStack(alignment: .leading, spacing: 14) {
            // 제목
            Text("월간 지출 현황")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.horizontal, 4)

            // ✅ 막대 그래프
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                let barCount = CGFloat(reversedValues.count)
                let barWidth: CGFloat = 28
                let spacing = max((totalWidth - (barWidth * barCount)) / (barCount + 1), 6)

                HStack(alignment: .bottom, spacing: spacing) {
                    ForEach(reversedValues.indices, id: \.self) { i in
                        VStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(activeMonth == displayLabels[i] ? Color.Primary : Color.LightBlue04)
                                .frame(width: barWidth, height: 150 * reversedValues[i])
                                .onTapGesture {
                                    // 선택/해제 처리
                                    selectedMonth = (selectedMonth == displayLabels[i]) ? nil : displayLabels[i]
                                }

                            Text(displayLabels[i])
                                .font(.caption2)
                                .foregroundColor(.black)
                                .padding(.top, 4)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .frame(height: 180)
            .padding(.vertical)

            Divider()

            // ✅ 하단 "n월 지출금액 ooo원" 표시
            if let index = displayLabels.firstIndex(of: activeMonth) {
                HStack {
                    Text("\(displayLabels[index]) 지출금액")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(reversedAmounts[index].formatted())원")
                        .font(.headline)
                        .foregroundColor(Color.Primary)
                }
                .padding(.top, 6)
            }
        }
        .frame(maxWidth: .infinity)
        // ✅ 초기 로드 시 최신월 자동 선택
        .onAppear {
            if selectedMonth == nil {
                selectedMonth = defaultMonth
            }
        }
    }
}

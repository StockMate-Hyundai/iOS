//
//  BarChartView.swift
//  StockMate
//
//  Created by Admin on 11/2/25.
//

import SwiftUI

struct BarChartView: View {
    let values: [CGFloat]       // 각 월별 비율값 (0~1)
    let labels: [String]        // 예: ["10", "09", "08", "07", "06"]
    let amounts: [Int]          // 예: [230000, 250000, 310000, 280000, 400000]
    @Binding var selectedMonth: String?

    var body: some View {
        // 최신월이 오른쪽에 오도록 역순 정렬
        let reversedValues = Array(values.reversed())
        let reversedLabels = Array(labels.reversed())
        let reversedAmounts = Array(amounts.reversed())

        // "07" → "7월" 형식 변환
        let displayLabels = reversedLabels.map { label in
            if let monthInt = Int(label) {
                return "\(monthInt)월"
            } else {
                return label
            }
        }

        // 기본 선택: 최신월
        let defaultMonth = displayLabels.last ?? ""
        let activeMonth = selectedMonth ?? defaultMonth

        VStack(alignment: .leading, spacing: 12) {
            // 막대 그래프
            GeometryReader { geometry in
                let chartHeight = geometry.size.height * 0.88 // 상하 여백 고려
                let totalWidth = geometry.size.width
                let barCount = CGFloat(reversedValues.count)
                let barWidth: CGFloat = 35
                let spacing = max((totalWidth - (barWidth * barCount)) / (barCount + 1), 6)

                HStack(alignment: .bottom, spacing: spacing) {
                    ForEach(reversedValues.indices, id: \.self) { i in
                        VStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(activeMonth == displayLabels[i] ? Color.Primary : Color.LightBlue04)
                                .frame(width: barWidth, height: max(chartHeight * reversedValues[i], 8)) // 최소 높이 보장
                                .onTapGesture {
                                    selectedMonth = (selectedMonth == displayLabels[i]) ? nil : displayLabels[i]
                                }

                            Text(displayLabels[i])
                                .font(.system(size: 13, weight: activeMonth == displayLabels[i] ? .semibold : .light)) // 선택된 막대는 글씨 bold
                                .padding(.top, 3)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .frame(height: 163) // 전체 그래프 영역 높이 확장
            .padding(.bottom, 7)

            Rectangle()
                .fill(Color.textGray2)
                .frame(height: 0.8)   // Divider보다 살짝 두껍게
                .padding(.horizontal, 4)


            // 하단 "n월 지출금액 ooo원" 표시
            if let index = displayLabels.firstIndex(of: activeMonth) {
                HStack {
                    Text("\(displayLabels[index]) 지출 현황")
                        .font(.system(size: 15, weight: .regular))
                    Spacer()
                    Text("\(reversedAmounts[index].formatted())원")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.Primary)
                }
                .padding(.horizontal,4)
                .padding(.vertical, 2)
            }
        }
        .frame(maxWidth: .infinity)
        // 초기 로드 시 최신월 자동 선택
        .onAppear {
            if selectedMonth == nil {
                selectedMonth = defaultMonth
            }
        }
    }
}

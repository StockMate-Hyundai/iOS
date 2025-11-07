//
//  DonutChartView.swift
//  StockMate
//
//  Created by Admin on 11/3/25.
//

import SwiftUI
import Charts

struct DonutChartView: View {
    let data: [CategorySpending]
    
    var total: Double {
        Double(data.map { $0.totalAmount }.reduce(0, +))
    }
    
    // ✅ 각 항목별 비율 계산
    var percentages: [Double] {
        data.map { total == 0 ? 0 : (Double($0.totalAmount) / total * 100) }
    }
    
    var colors: [Color] = [
        Color.Hstatus1,
        Color.Hstatus2,
        Color.Hstatus3,
        Color.Hstatus4,
        Color.Hstatus5
    ]
    
    var gradients: [AngularGradient] = [
        AngularGradient(gradient: Gradient(colors: [.pink, .orange]), center: .center),
        AngularGradient(gradient: Gradient(colors: [.blue, .teal]), center: .center),
        AngularGradient(gradient: Gradient(colors: [.green, .mint]), center: .center),
        AngularGradient(gradient: Gradient(colors: [.purple, .indigo]), center: .center),
        AngularGradient(gradient: Gradient(colors: [.gray, .black]), center: .center)
    ]

    
    var body: some View {
        HStack(alignment: .center, spacing: 24) {
            // ✅ 도넛 차트
            if total == 0 {
                Text("데이터 없음")
                    .foregroundColor(.gray)
            } else {
                Chart {
                    ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                        SectorMark(
                            angle: .value("지출", item.totalAmount),
                            innerRadius: .ratio(0.49),
                            angularInset: 1.9
                        )
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    colors[index % colors.count],
                                    colors[index % colors.count].opacity(0.5)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
//                        .foregroundStyle(colors[index % colors.count])
                        .cornerRadius(8.0)
                        // ✅ 도넛 안쪽에 비율 표시
                        .annotation(position: .overlay) {
                            let percentage = percentages[index]
                            Text("\(percentage, specifier: "%.1f")%")
                                .font(.system(size: 10, weight: .light))
                                .foregroundColor(.black)
                                .offset(y: -2)
                        }
                    }
                }
                .frame(height: 150)
                .chartLegend(.hidden) // 기본 범례 숨김
            }
            
            // ✅ 오른쪽 커스텀 범례
            VStack(alignment: .leading, spacing: 18) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    let percentage = percentages[index]
                    HStack(spacing: 7) {
                        Circle()
                            .fill(colors[index % colors.count])
                            .frame(width: 10, height: 10)
                        Text(item.categoryName)
                            .font(.system(size: 12, weight: .light))
                            .frame(width: 70, alignment: .leading)
                        Text("\(percentage, specifier: "%.1f")%")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    DonutChartView(data: [
        CategorySpending(categoryName: "전기/램프", totalAmount: 450000),
        CategorySpending(categoryName: "엔진/미션", totalAmount: 300000),
        CategorySpending(categoryName: "하체/바디", totalAmount: 150000),
        CategorySpending(categoryName: "내장/외장", totalAmount: 100000),
        CategorySpending(categoryName: "기타소모품", totalAmount: 50000)
    ])
}

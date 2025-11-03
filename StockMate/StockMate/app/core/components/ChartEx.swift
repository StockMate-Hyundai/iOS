//
//  ChartEx.swift
//  StockMate
//
//  Created by Admin on 11/3/25.
//

//import SwiftUI
//import Charts
//
//struct ChartEx: View {
//    let data: [CategorySpending]
//
//    init(data: [CategorySpending]) {
//        self.data = data
//    }
//
//    private var total: Double {
//        Double(data.map { $0.totalAmount }.reduce(0, +))
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("카테고리별 지출 현황")
//                .font(.headline)
//                .foregroundStyle(.primary)
//
//            Chart {
//                ForEach(data, id: \.categoryName) { item in
//                    SectorMark(
//                        angle: .value("지출 비율", item.totalAmount),
//                        innerRadius: .ratio(0.65),
//                        angularInset: 2.0
//                    )
//                    .foregroundStyle(by: .value("카테고리", item.categoryName))
//                    .cornerRadius(8.0)
//                    .annotation(position: .overlay) {
//                        if total > 0 {
//                            let percent = (Double(item.totalAmount) / total) * 100
//                            Text("\(Int(percent))%")
//                                .font(.caption)
//                                .foregroundStyle(.white)
//                        }
//                    }
//                }
//            }
//            .chartLegend(position: .bottom, alignment: .leading)
//            .frame(height: 260)
//
//            HStack {
//                Text("총합: \(Int(total).formatted())원")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                Spacer()
//            }
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ChartEx(data: [
//        CategorySpending(categoryName: "식비", totalAmount: 120000),
//        CategorySpending(categoryName: "교통", totalAmount: 85000),
//        CategorySpending(categoryName: "문화", totalAmount: 45000),
//        CategorySpending(categoryName: "쇼핑", totalAmount: 155000),
//        CategorySpending(categoryName: "기타", totalAmount: 30000)
//    ])
//}

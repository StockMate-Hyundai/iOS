//
//  HomeView.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import SwiftUI


struct HomeView: View {
    var body: some View {
        ScrollView {
             VStack(alignment: .leading, spacing: 24) {
                 // 상단 프로필
                 HStack(spacing: 16) {
                     Image("profile_sample") // 샘플 이미지
                         .resizable()
                         .frame(width: 50, height: 50)
                         .clipShape(Circle())
                     
                     VStack(alignment: .leading, spacing: 4) {
                         HStack {
                             Image("location")
                                 .foregroundColor(.gray)
                             Text("가산점")
                                 .foregroundColor(.gray)
                                 .font(.subheadline)
                         }
                         Text("Nadila Aulia")
                             .font(.title3.bold())
                             .foregroundColor(Color(hex: "#2B3A1A"))
                     }
                     
                     Spacer()
                     
                     Image("notification")
                         .font(.system(size: 20))
                         .foregroundColor(.gray)
                 }
                 .padding(.horizontal)
                 
                 
                 // 검색창
                 HStack {
                     Image(systemName: "magnifyingglass")
                         .foregroundColor(Color(hex: "#4B5565"))
                     Text("Search for Accessories")
                         .foregroundColor(.gray)
                     Spacer()
                 }
                 .padding()
                 .background(
                     RoundedRectangle(cornerRadius: 120)
                         .fill(Color(hex: "#EEF2F6"))
                 )
                 .overlay(
                     RoundedRectangle(cornerRadius: 120)
                         .stroke(Color(hex: "#9AA4B2"), lineWidth: 1)
                 )
                 .padding(.horizontal)

                 
                 
                 // 상태 요약 카드
                 HStack(spacing: 13) {
                     StatusItem(title: "입고", count: 77, color: .IncomingBg, icon: "incoming")
                     StatusItem(title: "부족", count: 33, color: .DangerBg, icon: "lack")
                     StatusItem(title: "승인대기", count: 27, color: .WarningBg, icon: "wait")
                     StatusItem(title: "반품/불량", count: 4, color: .DefectBg, icon: "defect")
                     StatusItem(title: "이동요청", count: 33, color: .TransferBg, icon: "transfer")
                 }
                 .padding()
                 .background(Color.white)
                 .cornerRadius(16)
                 .padding(.horizontal)
                 
                 
                 
                 // 도넛 차트 섹션
                 VStack(alignment: .leading, spacing: 18) {
                     Text("제목")
                         .font(.headline)
                         .padding()
                     
                     HStack{
                         DonutChartView()
                             .frame(height: 170)
                             .padding()
                             .background(Color.white)
                             .cornerRadius(16)
                             .shadow(color: .gray.opacity(0.1), radius: 4)
                         
                         Spacer()
                     }
                 }
                 .padding()
                 .background(Color.white)
                 .cornerRadius(16)
                 .padding(.horizontal)
                 
                 
                 
                 // 막대그래프 섹션
                 VStack(alignment: .leading, spacing: 8) {
                     Text("제목")
                         .font(.headline)
                         .padding(.top)
                         .padding(.leading)
                     
                     BarChartView()
                         .frame(height: 200)
//                         .padding()
                         .background(Color.white)
                         .shadow(color: .gray.opacity(0.1), radius: 4)
                 }
                 .padding()
                 .background(Color.white)
                 .cornerRadius(16)
                 .padding(.horizontal)
             }
             .padding(.vertical)
         }
        .background(Color.Light)
     }
}




// MARK: - 상태 아이템 컴포넌트
struct StatusItem: View {
    let title: String
    let count: Int
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 3) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.white)
                .padding(12)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .padding(.top, 5)
                .lineLimit(1)
            
            Text("\(count)건")
                .font(.caption)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.textGray1)
        }.frame(maxWidth: .infinity, minHeight: 70)
    }
}

// MARK: - 도넛 차트 (더미)
struct DonutChartView: View {
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.521)
                .stroke(Color.black, lineWidth: 40)
            Circle()
                .trim(from: 0.521, to: 0.749)
                .stroke(Color(hex: "#7DBBFF"), lineWidth: 40)
            Circle()
                .trim(from: 0.749, to: 0.888)
                .stroke(Color(hex: "#71DD8C"), lineWidth: 40)
            Circle()
                .trim(from: 0.888, to: 1)
                .stroke(Color(hex: "#A0BCE8"), lineWidth: 40)
        }
        .rotationEffect(.degrees(-89.9))
        .padding()
    }
}

// MARK: - 막대그래프 (더미)
struct BarChartView: View {
    let values: [CGFloat] = [0.89, 0.5, 0.9, 0.3, 0.7]
    let colors: [Color] = [
        Color(hex: "6BE6D3"), .black, Color(hex: "7DBBFF"), Color(hex: "B899EB"), Color(hex: "71DD8C")]
    // 6BE6D3
    var body: some View {
        HStack(alignment: .bottom, spacing: 33) {
            ForEach(0..<values.count, id: \.self) { i in
                RoundedRectangle(cornerRadius: 6)
                    .fill(colors[i])
                    .frame(width: 30, height: 170 * values[i])
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView()
}

//
//  HomeView.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import SwiftUI


struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var inventoryViewModel = InventoryViewModel()
    
    var body: some View {
        ScrollView {
             VStack(alignment: .leading, spacing: 15) {
                 // 상단 프로필
                 HStack(spacing: 16) {
                     ProfileCircleView(name: userViewModel.userInfo?.owner ?? "사용자", size: 50)
                     
                     VStack(alignment: .leading, spacing: 4) {
                         HStack {
                             Image("location")
                                 .foregroundColor(.gray)
                             Text(userViewModel.userInfo?.storeName ?? "가게명 없음")
                                 .foregroundColor(.gray)
                                 .font(.subheadline)
                         }
                         Text(userViewModel.userInfo?.owner ?? "이름 없음")
                             .font(.title3.bold())
                             .foregroundColor(Color(hex: "#2B3A1A"))
                     }
                     
                     Spacer()
                     
                     Image("notification")
                         .font(.system(size: 20))
                         .foregroundColor(.gray)
                         .padding(.trailing, 5)
                 }
                 .padding(.horizontal)
                 
                 // 🔍 검색창
                 HStack {
                     Image(systemName: "magnifyingglass")
                         .foregroundColor(.gray)

                     Text("부품을 검색하세요.")
                         .foregroundColor(.gray)
                     Spacer()
                 }
                 .padding()
                 .background(Color(.white))
                 .cornerRadius(9999)
                 .overlay(
                     RoundedRectangle(cornerRadius: 9999)
                         .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                 )
                 .padding(.horizontal)

                 
                 lackStockSection
                 
                 
                 // 도넛 차트 섹션
                 VStack(alignment: .leading, spacing: 18) {
                     Text("지난달 카테고리 별 지출")
                         .font(.headline)
                         .padding(4)
                     
                     HStack{
                         DonutChartView()
                             .frame(height: 130)
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
                     Text("지출 현황")
                         .font(.headline)
                         .padding(4)
                     
                     BarChartView()
                         .frame(height: 150)
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
        .task {
            // 카테고리 데이터 로드
            await inventoryViewModel.loadLackCountByCategory()
        }
        .onAppear {
            Task { await userViewModel.loadUserInfo() }
        }
        // 화면 디자인 시 잠시 주석처리
        // ✅ 세션 만료 시 자동으로 로그인 뷰로 이동
//        .onChange(of: userViewModel.shouldGoToLogin) { shouldGo in
//            if shouldGo {
//                print("세션 만료됨 → 로그인 화면으로 이동")
//                authViewModel.logout()
//            }
//        }
     }
    
    private var lackStockSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("재고 부족 조회")
                .font(.headline)
            HStack(spacing: 13) {
                ForEach(inventoryViewModel.lackCounts, id: \.id) { item in
                    NavigationLink {
                        LackListView(selectedCategory: item.categoryName)
                    } label: {
                        StatusItem(
                            title: item.categoryName,
                            count: item.count,
                            color: colorForCategory(item.categoryName),
                            icon: iconForCategory(item.categoryName)
                        )
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .frame(maxWidth: .infinity, minHeight: 70)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .padding(.horizontal)
    }
    

}


private func colorForCategory(_ category: String) -> Color {
    switch category {
        case "전기/램프": return .Hstatus1Bg
        case "엔진/미션": return .Hstatus2Bg
        case "하체/바디": return .Hstatus3Bg
        case "내장/외장": return .Hstatus4Bg
        case "기타소모품": return .Hstatus5Bg
        default: return .gray.opacity(0.3)
    }
}


private func iconForCategory(_ name: String) -> String {
    switch name {
        case "전기/램프": return "lightbulb"
        case "엔진/미션": return "cog"
        case "하체/바디": return "spanner"
        case "내장/외장": return "chair"
        case "기타소모품": return "package"
        default: return "questionmark"
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
                .padding(12)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 100))
            
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black)
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
        .LightBlue04, .Primary, .LightBlue04, .LightBlue04, .LightBlue04
    ]
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

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
//    @EnvironmentObject var dashboardViewModel: DashboardViewModel   //preview 용
    @StateObject private var dashboardViewModel = DashboardViewModel()
    
    @State private var selectedMonth: String? = nil  // ✅ 추가


    var body: some View {
        ScrollView {
             VStack(alignment: .leading, spacing: 15) {
                 // 상단 프로필
                 HStack(spacing: 16) {
                     ProfileCircleView(name: userViewModel.userInfo?.owner ?? "사용자", size: 50)
                     
                     VStack(alignment: .leading, spacing: 1) {
                         HStack(spacing: 2)  {
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
                 NavigationLink(destination: InventorySearchView()) {
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
                            .stroke(Color.GrayMordern400, lineWidth: 1)
                     )
                     .padding(.horizontal)
                 }
                 .buttonStyle(.plain)
                 
                 lackStockSection
                 
                 // 도넛 차트 섹션
                 VStack(alignment: .leading, spacing: 18) {
                     Text("지난달 카테고리 별 지출")
                         .font(.system(size: 15, weight: .semibold))
                         .padding(4)
                         .frame(maxWidth: .infinity, alignment: .leading) // ✅ 항상 왼쪽 정렬
                     
                     HStack {
                         if dashboardViewModel.isLoading {
                             ProgressView("불러오는 중...")
                                 .frame(height: 155)
                         } else if dashboardViewModel.categorySpendings.isEmpty {
                             Text("지난달 지출 내역이 없습니다.")
                                 .foregroundColor(.gray)
                                 .frame(maxWidth: .infinity)
                                 .frame(height: 155, alignment: .center)
                         } else {
                             DonutChartView(data: dashboardViewModel.categorySpendings)
                             .frame(height: 155)
                             .background(Color.white)
                             .cornerRadius(16)
                         }
                         
                         Spacer()
                     }
                 }
                 .padding()
                 .background(Color.white)
                 .cornerRadius(16)
                 .padding(.horizontal)

                 
                 // 막대그래프 섹션
                 VStack(alignment: .leading, spacing: 8) {
                     Text("월간 지출 현황")
                         .font(.system(size: 15, weight: .semibold))
                         .padding(4)
                         .frame(maxWidth: .infinity, alignment: .leading) // ✅ 항상 왼쪽 정렬
                     
                     ZStack { // ✅ 크기 고정용 컨테이너
                         RoundedRectangle(cornerRadius: 16)
                             .fill(Color.white)
                             .frame(height: 220) // ✅ 일정 높이 고정
                         if dashboardViewModel.isLoading {
                             ProgressView("데이터 불러오는 중...")
                                 .frame(height: 220)
                         } else if dashboardViewModel.monthlySpendings.isEmpty {
                             Text("최근 지출 내역이 없습니다.")
                                 .foregroundColor(.gray)
                                 .frame(height: 220)
                         } else {
                             BarChartView(
                                 values: dashboardViewModel.spendingRatios,
                                 labels: dashboardViewModel.monthLabels,
                                 amounts: dashboardViewModel.monthlySpendings.map { $0.totalAmount }, selectedMonth: $selectedMonth
                             )
                             .padding()
    //                         .frame(height: 220)
    //                         .background(Color.white)
    //                         .cornerRadius(16)
                         }
                     }
                 }
                 .padding()
                 .background(Color.white)
                 .cornerRadius(16)
                 .padding(.horizontal)
             }
             .padding(.vertical,5)
         }
        .background(Color.Light)
        .task {
            // 카테고리 데이터 로드
            await inventoryViewModel.loadLackCountByCategory()
            await dashboardViewModel.fetchMonthlySpending() // ✅ 추가
            await dashboardViewModel.fetchCategorySpending() // ✅ 추가
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
                .font(.system(size: 15, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading) // ✅ 항상 왼쪽 정렬 유지
            HStack(spacing: 13) {
                if inventoryViewModel.lackCounts.isEmpty {
                    // ✅ 데이터가 없을 때도 공간 확보
                    ForEach(0..<5) { _ in
                        StatusItem(
                            title: "-",
                            count: 0,
                            color: .gray.opacity(0.1),
                            icon: "questionmark"
                        )
                    }
                    .redacted(reason: .placeholder) // 로딩 중 효과 (선택사항)
                } else {
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
        default: return "uploadprogress"
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
                .font(.system(size: 12, weight: .semibold))
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



//#Preview {
//    HomeView()
//}

#Preview {
    let dashboardVM = DashboardViewModel()
    dashboardVM.categorySpendings = [
        CategorySpending(categoryName: "전기/램프", totalAmount: 450000),
        CategorySpending(categoryName: "엔진/미션", totalAmount: 300000),
        CategorySpending(categoryName: "하체/바디", totalAmount: 150000),
        CategorySpending(categoryName: "내장/외장", totalAmount: 100000),
        CategorySpending(categoryName: "기타소모품", totalAmount: 50000)
    ]
    
    return HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(dashboardVM) // ✅ 이제 진짜 연결됨!
}

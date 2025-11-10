//
//  InOutHistoryView.swift
//  StockMate
//
//  Created by Admin on 11/1/25.
//

import SwiftUI

struct InOutHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("불러오는 중...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if viewModel.histories.isEmpty {
                Text("입출고 내역이 없습니다.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // ✅ 날짜별로 그룹화 (최신순)
                let groupedHistories = Dictionary(grouping: viewModel.histories) { history in
                    history.createdAt.split(separator: "T").first.map(String.init) ?? ""
                }
                .sorted { $0.key > $1.key } // 최신순 정렬

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(groupedHistories, id: \.key) { date, histories in
                            VStack(alignment: .leading, spacing: 12) {
                                // ✅ 날짜 헤더
                                Text(formatDate(String(date)))
                                    .font(.headline)
                                    .padding(.leading, 25)
                                    .padding(.top, 8)

                                // ✅ 해당 날짜의 히스토리 카드들
                                ForEach(histories) { history in
                                    InOutHistoryCard(history: history)
                                }
                            }
                        }
                    }
                    .padding(.bottom)
                }
                .padding(.top)
            }
        }
        .background(Color.Light)
        .navigationTitle("입출고 히스토리")
        .navigationBarBackButtonHidden(true)
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
        .task {
            await viewModel.fetchInOutHistory()
        }
    }

    func formatDate(_ dateString: String) -> String {
        // yyyy-MM-dd → yyyy년 MM월 dd일
        let comps = dateString.split(separator: "-")
        guard comps.count == 3 else { return dateString }
        return "\(comps[0])년 \(comps[1])월 \(comps[2])일"
    }
}


struct InOutHistoryCard: View {
    let history: HistoryItem

    var body: some View {
        HStack(spacing: 10) {
            if let firstItem = history.items.first {
                HStack(alignment: .center, spacing: 12) {
                    AsyncImage(url: URL(string: firstItem.image)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(firstItem.korName)
                            .font(.system(size: 15))
                            .lineLimit(1)
                        if history.items.count > 1 {
                            Text("외 \(history.items.count - 1)개")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
            Spacer()
            
          // 입출고 상태
            Text(statusText(history.status))
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusBgColor(history.status))
                .foregroundColor(statusTextColor(history.status))
                .cornerRadius(12)
            
            if history.status == "RECEIVED", let orderId = history.orderId {
                NavigationLink(
                    destination: OrderDetailView(orderId: orderId, orderViewModel: OrderViewModel())
                ) {
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                }
                .buttonStyle(.plain)
            } else {
                NavigationLink(destination: ReleaseDetailView(history: history)) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(9)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }

    func formatDate(_ iso: String) -> String {
        String(iso.prefix(10)).replacingOccurrences(of: "-", with: ".")
    }

    func statusText(_ status: String) -> String {
        switch status {
        case "RECEIVED": return "입고"
        case "RELEASED": return "출고"
        default: return status
        }
    }

    func statusTextColor(_ status: String) -> Color {
        switch status {
        case "RELEASED": return .StatusGreen
        case "RECEIVED": return .StatusPurple
        default: return .gray
        }
    }

    func statusBgColor(_ status: String) -> Color {
        switch status {
        case "RELEASED": return .StatusGreenBg
        case "RECEIVED": return .StatusPurpleBg
        default: return Color.gray.opacity(0.15)
        }
    }
}

#Preview {
    InOutHistoryView()
}

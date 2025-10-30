//
//  ContentView.swift
//  StockMate
//
//  Created by Admin on 10/5/25.
//

import SwiftUI
//
//struct DottedLine: View {
//    var body: some View {
//        Rectangle()
//            .fill(Color.clear)
//            .frame(height: 1)
//            .overlay(
//                Rectangle()
//                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [3])) // <- 점선 패턴
//                    .foregroundColor(.gray)
//            )
//    }
//}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("위쪽")
//            DottedLine()
            Text("아래쪽")
        }
        .padding()
    }
}

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("임시 화면")
//        }
//        .padding()
//        HStack(spacing: 20) {
//            Image(systemName: "gearshape")
//                .font(.system(size: 40))
//                .foregroundColor(.blue)
//
//            Image(systemName: "lightbulb")
//                .font(.system(size: 40))
//                .foregroundColor(.cyan)
//        }
//    }
//}

#Preview {
    ContentView()
}

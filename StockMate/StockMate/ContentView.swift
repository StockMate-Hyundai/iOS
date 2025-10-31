//
//  ContentView.swift
//  StockMate
//
//  Created by Admin on 10/5/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("임시 화면")
        }
        .padding()
        HStack(spacing: 20) {
            Image(systemName: "gearshape")
                .font(.system(size: 40))
                .foregroundColor(.blue)

            Image(systemName: "lightbulb")
                .font(.system(size: 40))
                .foregroundColor(.cyan)
        }
    }
}

#Preview {
    ContentView()
}

//
//  PartBottomSheetView.swift
//  StockMate
//
//  Created by Admin on 11/3/25.
//

import SwiftUI

struct PartBottomSheetView: View {
    @EnvironmentObject var partStore: PartStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var partViewModel = PartViewModel()

    let part: PartDetail
    let onAddPart: () -> Void
    let onUseParts: () -> Void

    @State private var quantity: Int = 1
    @State private var isProcessing = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 16) {
            
            // ✅ 방금 스캔한 부품 미리보기
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: part.image)) { phase in
                    switch phase {
                    case .success(let img): img.resizable().scaledToFill()
                    default: Color.gray.opacity(0.3)
                    }
                }
                .frame(width: 48, height: 48)
                .cornerRadius(6)

                VStack(alignment: .leading, spacing: 4) {
                    Text(part.korName).font(.subheadline)
                    Text("\(part.model) / \(part.trim)")
                        .font(.caption).foregroundColor(.gray)
                    Text("\(part.price) 원").font(.subheadline)
                }

                Spacer()

                HStack(spacing: 8) {
                    Button(action: { if quantity > 1 { quantity -= 1 } }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2).foregroundColor(.blue)
                    }
                    Text("\(quantity)").frame(width: 44)
                    Button(action: { quantity += 1 }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2).foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            // ✅ 현재까지 누적된 부품 리스트
            List {
                ForEach(partStore.parts) { p in
                    HStack {
                        AsyncImage(url: URL(string: p.image)) { phase in
                            switch phase {
                            case .success(let img): img.resizable().scaledToFill()
                            default: Color.gray.opacity(0.3)
                            }
                        }
                        .frame(width: 48, height: 48)
                        .cornerRadius(6)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(p.korName).font(.subheadline)
                            Text("\(p.model) / \(p.trim)")
                                .font(.caption).foregroundColor(.gray)
                        }

                        Spacer()

                        HStack(spacing: 8) {
                            Button { partStore.updateQuantity(for: p.id, to: max(1, p.quantity - 1)) } label: {
                                Image(systemName: "minus.circle").font(.title2)
                            }
                            Text("\(p.quantity)").frame(width: 44)
                            Button { partStore.updateQuantity(for: p.id, to: p.quantity + 1) } label: {
                                Image(systemName: "plus.circle").font(.title2)
                            }
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { idxs in
                    idxs.forEach { partStore.removePart(partStore.parts[$0].id) }
                }
            }
            .frame(maxHeight: 240)
            .listStyle(.plain)

            Spacer()

            // ✅ 하단 버튼
            HStack(spacing: 12) {
                Button {
                    var newPart = part
                    newPart.quantity = quantity
                    partStore.addPart(newPart)
//                    onAddPart()  // QR 다시 준비
                    dismiss()
                } label: {
                    Text("부품 추가")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    Task { await handleUseNow() }
                } label: {
                    if isProcessing {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    } else {
                        Text("사용 처리")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                }
                .buttonStyle(.bordered)
                .disabled(isProcessing)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .presentationDetents([.medium, .large])
        .onAppear { quantity = part.quantity }
        .alert("알림", isPresented: $showAlert) {
            Button("확인") {}
        } message: { Text(alertMessage) }
    }

    private func handleUseNow() async {
        await MainActor.run { isProcessing = true }

        // ✅ 현재 부품이 아직 store에 없으면 추가
        if !partStore.parts.contains(where: { $0.id == part.id }) {
            var newPart = part
            newPart.quantity = quantity
            partStore.addPart(newPart)
        } else {
            partStore.updateQuantity(for: part.id, to: quantity)
        }

        let items = partStore.parts.map { ReleaseItemRequest(partId: $0.id, quantity: $0.quantity) }
        let result = await partViewModel.releaseParts(items: items)

        await MainActor.run {
            isProcessing = false
            switch result {
            case .success(let msg):
                alertMessage = msg
                showAlert = true
                partStore.clear()
                onUseParts()
                dismiss()
            case .failure(let err):
                alertMessage = err.message
                showAlert = true
            }
        }
    }
}

//import SwiftUI
//
//struct PartBottomSheetView: View {
//    @EnvironmentObject var partStore: PartStore
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var partViewModel = PartViewModel()
//
//    let part: PartDetail
//    let onAddPart: () -> Void
//    let onUseParts: () -> Void
//
//    @State private var quantity: Int = 1
//    @State private var isProcessing = false
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//
//    var body: some View {
//        VStack(spacing: 16) {
//            
//            // MARK: - 방금 스캔한 부품 미리보기 (추가 전)
//            HStack(spacing: 12) {
//                AsyncImage(url: URL(string: part.image)) { phase in
//                    switch phase {
//                    case .success(let img):
//                        img.resizable().scaledToFill()
//                    default:
//                        Color.gray.opacity(0.3)
//                    }
//                }
//                .frame(width: 48, height: 48)
//                .clipped()
//                .cornerRadius(6)
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(part.korName)
//                        .font(.subheadline)
//                    Text("\(part.model) / \(part.trim)")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                    Text("\(part.price) 원")
//                        .font(.subheadline)
//                }
//
//                Spacer()
//                
//                // ✅ 수정된 수량 조절 구역
//                HStack(spacing: 8) {
//                    Button(action: {
//                        if quantity > 1 { quantity -= 1 }
//                    }) {
//                        Image(systemName: "minus.circle.fill")
//                            .font(.title2)
//                            .foregroundColor(.blue)
//                    }
//
//                    Text("\(quantity)")
//                        .font(.body)
//                        .frame(width: 44, alignment: .center)
//
//                    Button(action: {
//                        quantity += 1
//                    }) {
//                        Image(systemName: "plus.circle.fill")
//                            .font(.title2)
//                            .foregroundColor(.blue)
//                    }
//
//                    Spacer()
//                }
//                .padding(.horizontal)
//            }
//            .padding(.horizontal)
//            .padding()
//
//            
//
//            List {
//                ForEach(partStore.parts.indices, id: \.self) { idx in
//                    let p = partStore.parts[idx]
//                    HStack {
//                        AsyncImage(url: URL(string: p.image)) { phase in
//                            switch phase {
//                            case .success(let img):
//                                img.resizable().scaledToFill()
//                            default:
//                                Color.gray.opacity(0.3)
//                            }
//                        }
//                        .frame(width: 48, height: 48)
//                        .clipped()
//                        .cornerRadius(6)
//
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text(p.korName)
//                                .font(.subheadline)
//                            Text("\(p.model) / \(p.trim)")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            Text("\(p.price) 원")
//                                .font(.subheadline)
//                        }
//
//                        Spacer()
//
//                        // ✅ 명확한 수량 표시 + +/- 버튼 (Stepper 대신 커스텀 컨트롤)
//                        HStack(spacing: 8) {
//                            Button {
//                                let newQty = max(1, p.quantity - 1)
//                                partStore.updateQuantity(for: p.id, to: newQty)
//                            } label: {
//                                Image(systemName: "minus.circle")
//                                    .font(.title2)
//                            }
//
//                            Text("\(p.quantity)")
//                                .font(.body)
//                                .frame(width: 44, alignment: .center)
//
//                            Button {
//                                let newQty = p.quantity + 1
//                                partStore.updateQuantity(for: p.id, to: newQty)
//                            } label: {
//                                Image(systemName: "plus.circle")
//                                    .font(.title2)
//                            }
//                        }
//                        .buttonStyle(.plain)
//                        .foregroundColor(.blue)
//                    }
//                    .padding()
//                }
//                .onDelete { idxs in
//                    idxs.forEach { i in
//                        let id = partStore.parts[i].id
//                        partStore.removePart(id)
//                    }
//                }
//            }
//            .frame(maxHeight: 240)
//            .listStyle(.plain)
////            List {
////                ForEach(partStore.parts) { p in
////                    HStack {
////                        AsyncImage(url: URL(string: p.image)) { phase in
////                            switch phase {
////                            case .success(let img):
////                                img.resizable().scaledToFill()
////                            default:
////                                Color.gray.opacity(0.3)
////                            }
////                        }
////                        .frame(width: 48, height: 48)
////                        .clipped()
////                        .cornerRadius(6)
////
////                        VStack(alignment: .leading, spacing: 4) {
////                            Text(p.korName)
////                                .font(.subheadline)
////                            Text("\(p.model) / \(p.trim)")
////                                .font(.caption)
////                                .foregroundColor(.gray)
////                        }
////
////                        Spacer()
////
////                        Stepper("", value: Binding(
////                            get: { p.quantity },
////                            set: { newVal in partStore.updateQuantity(for: p.id, to: newVal) }
////                        ), in: 1...999)
////                        .labelsHidden()
////                    }
////                    .padding(.vertical, 6)
////                }
////                .onDelete { idxs in
////                    idxs.forEach { i in
////                        let id = partStore.parts[i].id
////                        partStore.removePart(id)
////                    }
////                }
////            }
////            .frame(maxHeight: 240)
////            .listStyle(.plain)
//
//            Spacer()
//
//            // — 하단 버튼 —
//            HStack(spacing: 12) {
//                Button {
//                    var newPart = part
//                    newPart.quantity = quantity
//                    partStore.addPart(newPart)
//                    onAddPart()
//                    dismiss()
//                } label: {
//                    Text("부품 추가")
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                }
//                .buttonStyle(.borderedProminent)
//
//                Button {
//                    Task { await handleUseNow() }
//                } label: {
//                    if isProcessing {
//                        ProgressView()
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 12)
//                    } else {
//                        Text("사용 처리")
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 12)
//                    }
//                }
//                .buttonStyle(.bordered)
//                .disabled(isProcessing)
//            }
//            .padding(.horizontal)
//            .padding(.bottom, 8)
//        }
//        .presentationDetents([.medium, .large])
//        .onAppear {
//            quantity = part.quantity
//        }
//        .alert("알림", isPresented: $showAlert) {
//            Button("확인") {}
//        } message: {
//            Text(alertMessage)
//        }
//    }
//
//    private func handleUseNow() async {
//        await MainActor.run { isProcessing = true }
//
//        if !partStore.parts.contains(where: { $0.id == part.id }) {
//            var newPart = part
//            newPart.quantity = quantity
//            partStore.addPart(newPart)
//        } else {
//            partStore.updateQuantity(for: part.id, to: quantity)
//        }
//
//        let items = partStore.parts.map { ReleaseItemRequest(partId: $0.id, quantity: $0.quantity) }
//        let result = await partViewModel.releaseParts(items: items)
//
//        await MainActor.run {
//            isProcessing = false
//            switch result {
//            case .success(let msg):
//                alertMessage = msg
//                showAlert = true
//                partStore.clear()
//                onUseParts()
//                dismiss()
//            case .failure(let err):
//                alertMessage = err.message
//                showAlert = true
//            }
//        }
//    }
//}
//struct PartBottomSheetView: View {
//    @EnvironmentObject var partStore: PartStore
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var partViewModel = PartViewModel()
//
//    // 네가 원했던 시그니처: 반드시 이대로 호출 가능함
//    let part: PartDetail                       // 방금 스캔한 파트 (OutgoingScanView에서 전달)
//    let onAddPart: () -> Void                  // "부품 추가" 눌렀을 때 호출 (OutgoingScanView에서 resetScanState 등 처리)
//    let onUseParts: () -> Void                 // "사용 처리" 눌렀을 때 호출(옵션적 추가 동작)
//
//    @State private var quantity: Int = 1
//    @State private var isProcessing = false
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//
//    var body: some View {
//        VStack(spacing: 12) {
//            // — 단일(방금 스캔한) 파트 미리보기 —
//            HStack(spacing: 12) {
//                AsyncImage(url: URL(string: part.image)) { phase in
//                    switch phase {
//                    case .success(let img):
//                        img.resizable().scaledToFill()
//                    default:
//                        Color.gray.opacity(0.3)
//                    }
//                }
//                .frame(width: 84, height: 84)
//                .clipped()
//                .cornerRadius(8)
//
//                VStack(alignment: .leading, spacing: 6) {
//                    Text(part.korName)
//                        .font(.headline)
//                    Text("\(part.model) / \(part.trim)")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    Text("₩\(part.price)")
//                        .font(.subheadline)
//                }
//
//                Spacer()
//            }
//            .padding(.horizontal)
//
//            // 수량 조절 (바로 이 시트에서 조정한 수량이 추가/전송에 반영됨)
//            Stepper("수량: \(quantity)", value: $quantity, in: 1...999)
//                .padding(.horizontal)
//
//            Divider()
//                .padding(.vertical, 6)
//
//            // — 누적된 파트 리스트 (PartStore) —
//            Text("추가된 부품 목록")
//                .font(.subheadline)
//                .bold()
//                .padding(.horizontal)
//
//            List {
//                ForEach(partStore.parts) { p in
//                    HStack {
//                        AsyncImage(url: URL(string: p.image)) { phase in
//                            switch phase {
//                            case .success(let img):
//                                img.resizable().scaledToFill()
//                            default:
//                                Color.gray.opacity(0.3)
//                            }
//                        }
//                        .frame(width: 48, height: 48)
//                        .clipped()
//                        .cornerRadius(6)
//
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text(p.korName)
//                                .font(.subheadline)
//                            Text("\(p.model) / \(p.trim)")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//
//                        Spacer()
//
//                        // stepper 바인딩은 store 업데이트로 연결
//                        Stepper("", value: Binding(
//                            get: { p.quantity },
//                            set: { newVal in partStore.updateQuantity(for: p.id, to: newVal) }
//                        ), in: 1...999)
//                        .labelsHidden()
//                    }
//                    .padding(.vertical, 6)
//                }
//                .onDelete { idxs in
//                    idxs.forEach { i in
//                        let id = partStore.parts[i].id
//                        partStore.removePart(id)
//                    }
//                }
//            }
//            .frame(maxHeight: 240)
//            .listStyle(.plain)
//
//            Spacer()
//
//            // 하단 버튼
//            HStack(spacing: 12) {
//                // 1) 부품 추가: 방금 스캔한 파트를 (현재 quantity로) partStore에 추가하고
//                //    호출자에게 알려줌 (예: resetScanState)
//                Button {
//                    var newPart = part
//                    newPart.quantity = quantity
//                    partStore.addPart(newPart)
//
//                    // 호출자 (OutgoingScanView)에게 알림 — 여기서 스캔 상태 초기화 등 처리
//                    onAddPart()
//                    // 시트 닫기
//                    dismiss()
//                } label: {
//                    Text("부품 추가")
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                }
//                .buttonStyle(.borderedProminent)
//
//                // 2) 사용 처리: PartStore 전체를 서버로 보내는 흐름 (뷰모델 사용)
//                Button {
//                    Task {
//                        await handleUseNow()
//                    }
//                } label: {
//                    if isProcessing {
//                        ProgressView()
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 12)
//                    } else {
//                        Text("사용 처리")
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 12)
//                    }
//                }
//                .buttonStyle(.bordered)
//                .disabled(isProcessing)
//            }
//            .padding(.horizontal)
//            .padding(.bottom, 8)
//        }
//        .presentationDetents([.medium, .large])
//        .onAppear {
//            quantity = part.quantity
//        }
//        .alert("알림", isPresented: $showAlert) {
//            Button("확인") {}
//        } message: {
//            Text(alertMessage)
//        }
//    }
//
//    // 사용 처리 로직 (뷰모델에 구현된 releaseParts 사용)
//    private func handleUseNow() async {
//        await MainActor.run { isProcessing = true }
//
//        // 현재 시트에서 조정한 수량이 partStore에 반영되어야 함:
//        if !partStore.parts.contains(where: { $0.id == part.id }) {
//            var newPart = part
//            newPart.quantity = quantity
//            partStore.addPart(newPart)
//        } else {
//            partStore.updateQuantity(for: part.id, to: quantity)
//        }
//
//        let items = partStore.parts.map { ReleaseItemRequest(partId: $0.id, quantity: $0.quantity) }
//        let result = await partViewModel.releaseParts(items: items)
//
//        await MainActor.run {
//            isProcessing = false
//            switch result {
//            case .success(let msg):
//                alertMessage = msg
//                showAlert = true
//                // 성공 시 리스트 비우기
//                partStore.clear()
//                // 호출자도 알림을 원하면 onUseParts 호출
//                onUseParts()
//                dismiss()
//            case .failure(let err):
//                alertMessage = err.message
//                showAlert = true
//            }
//        }
//    }
//}

//import SwiftUI
//
//struct PartBottomSheetView: View {
//    @EnvironmentObject var partStore: PartStore
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var partViewModel = PartViewModel()
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Text("추가된 부품 목록")
//                .font(.headline)
//                .padding(.top, 8)
//
//            List {
//                ForEach(partStore.parts) { part in
//                    VStack(alignment: .leading, spacing: 4) {
//                        HStack {
//                            AsyncImage(url: URL(string: part.image)) { image in
//                                image.resizable().scaledToFit()
//                            } placeholder: {
//                                Color.gray
//                            }
//                            .frame(width: 60, height: 60)
//                            .cornerRadius(8)
//
//                            VStack(alignment: .leading) {
//                                Text(part.korName).font(.headline)
//                                Text("\(part.model) / \(part.trim)")
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
//
//                            Spacer()
//
//                            Stepper("", value: Binding(
//                                get: { part.quantity },
//                                set: { newValue in
//                                    partStore.updateQuantity(for: part.id, to: newValue)
//                                }
//                            ), in: 1...100)
//                            .labelsHidden()
//                        }
//
//                        Text("₩\(part.price)")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//                    .padding(.vertical, 4)
//                }
//                .onDelete { indexSet in
//                    indexSet.forEach { idx in
//                        partStore.removePart(partStore.parts[idx].id)
//                    }
//                }
//            }
//
//            HStack {
//                Button("부품 추가") {
//                    dismiss() // 다시 QR 스캔 화면으로 복귀
//                }
//                .buttonStyle(.borderedProminent)
//
//                Button("사용 처리") {
//                    Task {
//                        let payload = partStore.parts.map {
//                            ReleaseItemRequest(partId: $0.id, quantity: $0.quantity)
//                        }
//                        let result = await partViewModel.releaseParts(items: payload)
//                        switch result {
//                        case .success(let msg):
//                            print("✅ 사용처리 성공:", msg)
//                            partStore.clear()
//                            dismiss()
//                        case .failure(let err):
//                            print("❌ 실패:", err.message)
//                        }
//                    }
//                }
//                .buttonStyle(.bordered)
//            }
//            .padding()
//        }
//        .presentationDetents([.medium, .large])
//    }
//}

//import SwiftUI
//
//struct PartBottomSheetView: View {
//    @EnvironmentObject var partStore: PartStore
//    @Environment(\.dismiss) private var dismiss
//
//    // part: 지금 방금 API로 받아온 파트 (아직 PartStore에 추가되지 않을 수 있음)
//    let part: PartDetail
//
//    @State private var quantity = 1
//    @State private var isProcessingUse = false
//    @State private var showErrorAlert = false
//    @State private var errorMessage = ""
//
//    var body: some View {
//        VStack(spacing: 12) {
//            AsyncImage(url: URL(string: part.image)) { phase in
//                switch phase {
//                case .success(let image):
//                    image.resizable().scaledToFit()
//                default:
//                    Color.gray
//                }
//            }
//            .frame(height: 150)
//
//            Text(part.korName)
//                .font(.headline)
//            Text("\(part.model) / \(part.trim)")
//                .font(.subheadline)
//            Text("₩\(part.price)")
//                .font(.title3)
//                .bold()
//
//            Stepper("수량: \(quantity)", value: $quantity, in: 1...100)
//                .padding(.vertical)
//
//            HStack(spacing: 12) {
//                // 1) 부품 추가: 현재 파트를 PartStore에 추가한 뒤 닫아서 QR 스캔 화면으로 돌아감
//                Button(action: {
//                    addCurrentPartToStoreAndReturnToScanner()
//                }) {
//                    Text("부품 추가")
//                        .frame(maxWidth: .infinity)
//                }
//                .buttonStyle(.bordered)
//
//                // 2) 사용 처리: PartStore의 항목들(및 현재 파트가 미추가 상태면 그것도 포함)을 서버로 전송
//                Button(action: {
//                    Task {
//                        await handleUseNow()
//                    }
//                }) {
//                    if isProcessingUse {
//                        ProgressView()
//                            .frame(maxWidth: .infinity)
//                    } else {
//                        Text("사용 처리")
//                            .frame(maxWidth: .infinity)
//                    }
//                }
//                .buttonStyle(.borderedProminent)
//                .disabled(isProcessingUse)
//            }
//        }
//        .padding()
//        .alert("오류", isPresented: $showErrorAlert) {
//            Button("확인", role: .cancel) { }
//        } message: {
//            Text(errorMessage)
//        }
//        .onAppear {
//            // 기본 수량을 part의 quantity가 이미 설정되어 있으면 그걸로. (일반적으로 1)
//            quantity = part.quantity
//        }
//    }
//
//    // MARK: - Helpers
//
//    // 부품 추가 누르면 현재 파트를 PartStore에 넣고 바텀시트 닫음 (QR 스캔 화면으로 돌아감)
//    private func addCurrentPartToStoreAndReturnToScanner() {
//        var newPart = part
//        newPart.quantity = quantity
//        partStore.addPart(newPart)
//        dismiss() // QR 화면으로 돌아감 (QR 화면이 스택에 남아있다면 바로 보일 것)
//    }
//
//    // 사용 처리: 현재 파트를 포함해 전부 전송
//    private func handleUseNow() async {
//        isProcessingUse = true
//
//        // 현재 part가 이미 store에 있는지 확인
//        if !partStore.parts.contains(where: { $0.id == part.id }) {
//            // 자동으로 포함시켜서 누락 방지
//            var newPart = part
//            newPart.quantity = quantity
//            partStore.addPart(newPart)
//        } else {
//            // 이미 있으면 사용자가 바텀시트에서 조정한 수량을 반영
//            partStore.updateQuantity(for: part.id, to: quantity)
//        }
//
//        // payload 생성
//        let payload = partStore.makeRequestPayload()
//        // ReleaseItemRequest로 변환 (예시)
//        let items = partStore.parts.map { ReleaseItemRequest(partId: $0.id, quantity: $0.quantity) }
//
//        // 실제로는 네가 사용 중인 ViewModel/Repository를 호출하는 게 좋음 (여기서는 간단 시도)
//        let repository = PartRepositoryImpl()
//        let result = await repository.releaseParts(items: items)
//
//        await MainActor.run {
//            isProcessingUse = false
//            switch result {
//            case .success(let apiResponse):
//                // 성공 메시지 처리 — 필요하면 화면 닫고 partStore.clear() 호출
//                // 예: 사용 처리가 성공하면 임시 저장 리스트 비우기
//                partStore.parts.removeAll()
//                dismiss()
//            case .failure(let appError):
//                // 실패 시 메시지 보여주기
//                errorMessage = appError.message
//                showErrorAlert = true
//            }
//        }
//    }
//}

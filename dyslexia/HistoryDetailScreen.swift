//
//  HistoryDetailScreen.swift
//  dyslexia

import SwiftUI

struct HistoryDetailScreen: View {
    private var record: WordRecord
    private var onBack: () -> Void

    init(record: WordRecord, onBack: @escaping () -> Void) {
        self.record = record
        self.onBack = onBack
    }

    var body: some View {
        VStack(alignment: .leading) {
            Button("Back") {
                onBack()
            }
            .buttonStyle(.borderedProminent)

            Spacer().frame(height: 8)

            Text("Word: \(record.word)")
            Text("Points: \(record.point)")
            Text("Moves: \(record.moves)")
            Text("Seconds: \(record.seconds)")
            Text(record.point > 0 ? "Status: Complete" : "Status: Incomplete")

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(16)
        .navigationBarBackButtonHidden(true)
    }
}

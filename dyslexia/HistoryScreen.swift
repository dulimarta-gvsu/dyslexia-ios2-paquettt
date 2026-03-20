//
//  HistoryScreen.swift
//  dyslexia

import SwiftUI

struct HistoryScreen: View {
    @ObservedObject var viewModel: AppViewModel
    private var onBack: () -> Void
    private var onOpenDetail: (Int) -> Void

    init(
        viewModel: AppViewModel,
        onBack: @escaping () -> Void,
        onOpenDetail: @escaping (Int) -> Void
    ) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.onBack = onBack
        self.onOpenDetail = onOpenDetail
    }

    var body: some View {
        VStack {
            HStack {
                Button("Back") {
                    onBack()
                }
                .buttonStyle(.borderedProminent)

                Spacer()

                Text("Game History")
                    .font(.title3)
                    .bold()
            }

            HStack {
                Button("Word") {
                    viewModel.sortByWord()
                }
                .buttonStyle(.borderedProminent)

                Button("Points") {
                    viewModel.sortByPoint()
                }
                .buttonStyle(.borderedProminent)

                Button("Moves") {
                    viewModel.sortByMoves()
                }
                .buttonStyle(.borderedProminent)

                Button("Time") {
                    viewModel.sortBySeconds()
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer().frame(height: 12)

            ScrollView {
                LazyVStack {
                    ForEach(Array(viewModel.gameHistory.enumerated()), id: \.offset) { index, record in
                        let isComplete = record.point > 0
                        let bg = isComplete ? Color.green.opacity(0.25) : Color.red.opacity(0.20)

                        Button {
                            onOpenDetail(index)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Word: \(record.word)")
                                        .foregroundColor(.black)
                                    Text(isComplete ? "Complete" : "Incomplete")
                                        .foregroundColor(.black)
                                }

                                Spacer()

                                VStack(alignment: .trailing) {
                                    Text("Pts: \(record.point)")
                                        .foregroundColor(.black)
                                    Text("Moves: \(record.moves)")
                                        .foregroundColor(.black)
                                    Text("Sec: \(record.seconds)")
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(bg)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(.black, lineWidth: 1)
                            )
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
        }
        .padding(12)
        .navigationBarBackButtonHidden(true)
    }
}

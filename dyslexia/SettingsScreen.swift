//
//  SettingsScreen.swift
//  dyslexia

import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var viewModel: AppViewModel
    private var onBack: () -> Void

    @State private var minLenValue: Double = 3
    @State private var maxLenValue: Double = 12

    init(viewModel: AppViewModel, onBack: @escaping () -> Void) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.onBack = onBack
    }

    var body: some View {
        VStack(alignment: .leading) {
            Button("Back") {
                onBack()
            }
            .buttonStyle(.borderedProminent)

            Spacer().frame(height: 16)

            Text("Word Length Range: \(viewModel.minWordLen) - \(viewModel.maxWordLen)")

            Text("Minimum Length")
            Slider(
                value: $minLenValue,
                in: 3...12,
                step: 1
            ) { _ in
                viewModel.setWordLengthRange(min: Int(minLenValue), max: Int(maxLenValue))
            }

            Text("Maximum Length")
            Slider(
                value: $maxLenValue,
                in: 3...12,
                step: 1
            ) { _ in
                viewModel.setWordLengthRange(min: Int(minLenValue), max: Int(maxLenValue))
            }

            Spacer().frame(height: 16)

            Text("Letter Tile Color (RGB): \(viewModel.tileR), \(viewModel.tileG), \(viewModel.tileB)")

            Text("R")
            Slider(
                value: Binding(
                    get: { Double(viewModel.tileR) },
                    set: { viewModel.setTileR(v: Int($0)) }
                ),
                in: 0...255,
                step: 1
            )

            Text("G")
            Slider(
                value: Binding(
                    get: { Double(viewModel.tileG) },
                    set: { viewModel.setTileG(v: Int($0)) }
                ),
                in: 0...255,
                step: 1
            )

            Text("B")
            Slider(
                value: Binding(
                    get: { Double(viewModel.tileB) },
                    set: { viewModel.setTileB(v: Int($0)) }
                ),
                in: 0...255,
                step: 1
            )

            Spacer()
        }
        .padding(16)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            minLenValue = Double(viewModel.minWordLen)
            maxLenValue = Double(viewModel.maxWordLen)
        }
    }
}

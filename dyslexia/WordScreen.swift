//
//  WordScreen.swift
//  dyslexia

import SwiftUI
import Combine

struct WordScreen: View {
    @ObservedObject var viewModel: AppViewModel
    private var onOpenHistory: () -> Void
    private var onOpenSettings: () -> Void

    @State private var letters: [Letter] = []

    init(
        viewModel: AppViewModel,
        onOpenHistory: @escaping () -> Void,
        onOpenSettings: @escaping () -> Void
    ) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.onOpenHistory = onOpenHistory
        self.onOpenSettings = onOpenSettings
    }

    private var tileColor: Color {
        Color(
            red: Double(viewModel.tileR) / 255.0,
            green: Double(viewModel.tileG) / 255.0,
            blue: Double(viewModel.tileB) / 255.0
        )
    }
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Button("History") {
                        onOpenHistory()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Settings") {
                        onOpenSettings()
                    }
                    .buttonStyle(.borderedProminent)
                }

                Button("New Word") {
                    viewModel.startNewGame()
                }
                .buttonStyle(.borderedProminent)

                Text("Moves: \(viewModel.moves)")
                    .foregroundColor(.white)

                Text("Total Score: \(viewModel.totalScore)")
                    .foregroundColor(.white)

                if viewModel.timeSpentMillis > 0 {
                    let seconds = Double(viewModel.timeSpentMillis) / 1000.0
                    Text(String(format: "Time: %.1fs", seconds))
                        .foregroundColor(.white)
                }

                if let msg = viewModel.congratsMessage {
                    Text(msg)
                        .foregroundColor(.white)
                        .font(.headline)
                }

                Spacer()

                LetterGroup(letters: $letters, tileColor: tileColor) { arr in
                    viewModel.rearrange(to: arr)
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(viewModel.$letters) { newValue in
            letters = newValue
        }
    }
    }

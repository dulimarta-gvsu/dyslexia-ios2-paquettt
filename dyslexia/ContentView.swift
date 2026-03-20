//
//  ContentView.swift
//  dyslexia

import SwiftUI
import Combine

struct ContentView: View {
    init(viewModel: AppViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    @ObservedObject private var viewModel: AppViewModel
    @ObservedObject var navCtrl = MyNavigator()

    var body: some View {
        NavigationStack(path: $navCtrl.navPath) {
            WordScreen(
                viewModel: viewModel,
                onOpenHistory: { navCtrl.navigate(to: .History) },
                onOpenSettings: { navCtrl.navigate(to: .Settings) }
            )
            .navigationDestination(for: Route.self) {
                switch ($0) {
                case .History:
                    HistoryScreen(
                        viewModel: viewModel,
                        onBack: { navCtrl.navigateBack() },
                        onOpenDetail: { index in
                            navCtrl.navigate(to: .HistoryDetail(index))
                        }
                    )
                case .HistoryDetail(let index):
                    if index >= 0 && index < viewModel.gameHistory.count {
                        HistoryDetailScreen(
                            record: viewModel.gameHistory[index],
                            onBack: { navCtrl.navigateBack() }
                        )
                    }
                case .Settings:
                    SettingsScreen(
                        viewModel: viewModel,
                        onBack: { navCtrl.navigateBack() }
                    )
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: AppViewModel())
    }
}
#endif

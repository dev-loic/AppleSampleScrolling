//
//  NavigatorView.swift
//  AppleSampleScrolling
//
//  Created by Loïc Saillant on 28/08/2025.
//

import SwiftUI
import Combine

struct NavigatorView: View {
    @StateObject var viewModel = NavigatorViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            MainView(viewModel: viewModel.mainViewModel)
                .navigationTitle("Main")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: NavigatorViewModel.Route.self) { route in
                    switch route {
                    case .scrolling(let position):
                        ScrollingView(viewModel: ScrollingViewModel(position: position))
                            .navigationTitle("ScrollingView")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
        }
    }
}

@MainActor
final class NavigatorViewModel: ObservableObject {
    enum Route: Hashable { case scrolling(position: Int) }

    @Published var path: [Route] = []

    lazy var mainViewModel: MainViewModel = {
        let vm = MainViewModel()
        vm.onOpen = { [weak self] position in
            self?.path.append(.scrolling(position: position))
        }
        return vm
    }()
}

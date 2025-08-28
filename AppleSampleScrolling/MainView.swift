//
//  MainView.swift
//  AppleSampleScrolling
//
//  Created by Loïc Saillant on 28/08/2025.
//

import SwiftUI
import Combine

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome 🎉")
                .font(.headline)
            
            ForEach(0..<10, id: \.self) { i in
                Button("Open position \(i)") {
                    viewModel.openButtonTapped(i)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

@MainActor
final class MainViewModel: ObservableObject {
    
    public enum FocusedItem {
        case position(Int)
    }
    
    /// Assigned by NavigatorViewModel
    var onOpen: ((Int) -> Void)?

    func openButtonTapped(_ position: Int) {
        onOpen?(position)
    }
}

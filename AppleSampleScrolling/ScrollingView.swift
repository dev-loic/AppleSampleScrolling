//
//  ScrollingView.swift
//  AppleSampleScrolling
//
//  Created by Loïc Saillant on 28/08/2025.
//

import SwiftUI
import Combine

struct ScrollingView: View {
    
    struct Constants {
        static let itemsHeight: CGFloat = 100
    }
    
    @ObservedObject var viewModel: ScrollingViewModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.rows) { row in
                    Text(row.title)
                        .frame(maxWidth: .infinity, minHeight: Constants.itemsHeight, alignment: .leading)
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                        .id(row.id)           // id used by .scrollPosition(id:)
                }
            }
            .scrollTargetLayout()
            .padding(.vertical)
        }
        // Keep the anchor item stable in view as content changes
        .scrollPosition(id: $viewModel.scrollViewPosition)
        .navigationTitle("ScrollingView")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@MainActor
final class ScrollingViewModel: ObservableObject {
    
    struct Constants {
        static let nbOfItems = 10
    }
    
    struct Row: Identifiable, Hashable {
        let id: Int
        let title: String
    }

    // Track the currently "focused" row by id for .scrollPosition(id:)
    @Published var scrollViewPosition: Int? = nil
    @Published var rows: [Row] = []

    // Choose a stable "center" id we want to preserve across insertions
    private let anchorID = 100
    private let position: Int

    init(position: Int) {
        // Start with a single element
        rows = [Row(id: anchorID, title: "Focused item \(anchorID)")]
        scrollViewPosition = anchorID
        self.position = position

        // Fake a network call after 3s -> insert 2 above and 3 below
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            await MainActor.run { insertAroundAnchor() }
        }
    }

    private func insertAroundAnchor() {
        // Build new rows around the anchor
        var newAbove: [Row] = []
        for i in 0..<position {
            newAbove.append(Row(id: anchorID - (position - i), title: "Item \(anchorID - (position - i))"))
        }
        
        var newBelow: [Row] = []
        for i in 0..<Constants.nbOfItems - newAbove.count - 1 {
            newBelow.append(Row(id: anchorID + i + 1, title: "Item \(anchorID + i + 1)"))
        }
        // Merge while preserving ordering (ascending ids)
        var all = newAbove + rows + newBelow
        all.sort { $0.id < $1.id }
            rows = all
            scrollViewPosition = anchorID
    }
}

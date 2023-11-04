//
//  EmojisListView.swift
//  BlissMoji
//
//  Created by António Ramos on 04/11/2023.
//

import SwiftUI

struct EmojisListView: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    
    func fetchData() {
        Task {
            do {
                let adapter = EmojiAdapter(modelContext: modelContext)
                let emojis = try await adapter.fetchEmojisData()
                await MainActor.run {
                    emojis.forEach {
                        print($0.name)
                    }
                }
            } catch {
                await MainActor.run {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    EmojisListView()
}

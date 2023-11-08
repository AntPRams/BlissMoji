import SwiftUI

struct ListItemView: View {
    
    let repoName: String
    
    var body: some View {
        Text(repoName)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ListItemView(repoName: "test")
}

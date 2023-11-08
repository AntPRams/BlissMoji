import SwiftUI

struct ListItemView: View {
    
    let repoName: String
    
    var body: some View {
        Text(repoName)
    }
}

#Preview {
    ListItemView(repoName: "test")
}

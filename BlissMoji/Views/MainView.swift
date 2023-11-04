import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Image(uiImage: UIImage())
                .clipShape(.circle)
            Button {
                //action
            } label: {
                Text(Localizable.emojisButton)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    MainView()
}

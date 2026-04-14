import SwiftUI

struct RPGCardView<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .padding(30)
            .background(Color.rpgCard)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
            .fadeInOnAppear()
    }
}
